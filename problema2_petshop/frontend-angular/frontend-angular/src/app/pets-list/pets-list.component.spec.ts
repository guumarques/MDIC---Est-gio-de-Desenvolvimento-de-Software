import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PetsList } from './pets-list';

describe('PetsList', () => {
  let component: PetsList;
  let fixture: ComponentFixture<PetsList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PetsList]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PetsList);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
