from fastapi import FastAPI, HTTPException, Query, Path
from pydantic import BaseModel, constr
from typing import List, Optional
from datetime import datetime
import databases
import sqlalchemy
import os

# URL do banco de dados (configure aqui sua conexão real)
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/postgres")

database = databases.Database(DATABASE_URL)
metadata = sqlalchemy.MetaData()

pets = sqlalchemy.Table(
    "pets",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("nome", sqlalchemy.String, nullable=False),
    sqlalchemy.Column("especie", sqlalchemy.String, nullable=False),
    sqlalchemy.Column("tutor", sqlalchemy.String, nullable=False),
    sqlalchemy.Column("criado_em", sqlalchemy.TIMESTAMP(timezone=True), server_default=sqlalchemy.func.now()),
)

servicos = sqlalchemy.Table(
    "servicos",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("pet_id", sqlalchemy.Integer, nullable=False),
    sqlalchemy.Column("descricao", sqlalchemy.String, nullable=False),
    sqlalchemy.Column("data", sqlalchemy.TIMESTAMP(timezone=True), server_default=sqlalchemy.func.now()),
)

app = FastAPI()

# Modelos Pydantic para validação

class PetCreate(BaseModel):
    nome: constr(min_length=1)
    especie: constr(min_length=1)
    tutor: constr(min_length=1)

class PetOut(BaseModel):
    id: int
    nome: str
    especie: str
    tutor: str
    criado_em: datetime

class ServicoCreate(BaseModel):
    descricao: constr(min_length=1)

class ServicoOut(BaseModel):
    id: int
    pet_id: int
    descricao: str
    data: datetime

# Eventos para conectar e desconectar do banco

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

# Endpoints

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/pets", response_model=List[PetOut])
async def listar_pets(busca: Optional[str] = Query(None), especie: Optional[str] = Query(None)):
    query = pets.select()
    if busca:
        query = query.where(pets.c.nome.ilike(f"%{busca}%"))
    if especie:
        query = query.where(pets.c.especie == especie)
    return await database.fetch_all(query)

@app.post("/pets", response_model=PetOut)
async def criar_pet(pet: PetCreate):
    query = pets.insert().values(
        nome=pet.nome,
        especie=pet.especie,
        tutor=pet.tutor
    ).returning(*pets.c)
    pet_created = await database.fetch_one(query)
    return pet_created

@app.delete("/pets/{id}", status_code=204)
async def deletar_pet(id: int = Path(...)):
    query = pets.delete().where(pets.c.id == id)
    result = await database.execute(query)
    if result == 0:
        raise HTTPException(status_code=404, detail="Pet não encontrado")
    return

@app.post("/pets/{id}/servicos", response_model=ServicoOut)
async def adicionar_servico(id: int, servico: ServicoCreate):
    query_pet = pets.select().where(pets.c.id == id)
    pet = await database.fetch_one(query_pet)
    if not pet:
        raise HTTPException(status_code=404, detail="Pet não encontrado")
    query = servicos.insert().values(
        pet_id=id,
        descricao=servico.descricao
    ).returning(*servicos.c)
    servico_created = await database.fetch_one(query)
    return servico_created

@app.get("/pets/{id}/servicos", response_model=List[ServicoOut])
async def listar_servicos(id: int, limite: int = Query(5)):
    query = servicos.select().where(servicos.c.pet_id == id).order_by(servicos.c.data.desc()).limit(limite)
    return await database.fetch_all(query)
