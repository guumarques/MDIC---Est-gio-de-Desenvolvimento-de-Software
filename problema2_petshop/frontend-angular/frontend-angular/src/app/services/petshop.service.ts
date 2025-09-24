import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Pet {
  id: number;
  nome: string;
  especie: string;
  tutor: string;
  criado_em: string;
}

export interface Servico {
  id: number;
  pet_id: number;
  descricao: string;
  data: string;
}

@Injectable({
  providedIn: 'root'
})
export class PetshopService {
  private baseUrl = 'http://localhost:8000'; // Ajuste a porta conforme seu backend

  constructor(private http: HttpClient) {}

  getPets(busca: string = '', especie: string = ''): Observable<Pet[]> {
    let url = `${this.baseUrl}/pets?busca=${busca}&especie=${especie}`;
    return this.http.get<Pet[]>(url);
  }

  addPet(pet: Partial<Pet>): Observable<Pet> {
    return this.http.post<Pet>(`${this.baseUrl}/pets`, pet);
  }

  deletePet(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/pets/${id}`);
  }

  addServico(petId: number, descricao: string): Observable<Servico> {
    return this.http.post<Servico>(`${this.baseUrl}/pets/${petId}/servicos`, { descricao });
  }

  getServicos(petId: number, limite: number = 5): Observable<Servico[]> {
    return this.http.get<Servico[]>(`${this.baseUrl}/pets/${petId}/servicos?limite=${limite}`);
  }
}
