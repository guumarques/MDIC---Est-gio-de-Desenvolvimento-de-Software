import { TestBed } from '@angular/core/testing';

import { Petshop } from './petshop';

describe('Petshop', () => {
  let service: Petshop;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Petshop);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
