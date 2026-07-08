export interface Airline {
  id: string;
  iataCode: string;
  icaoCode: string | null;
  name: string;
  logoUrl: string | null;
  country: string;
  countryCode: string;
  alliance: string | null;
  isActive: boolean;
  iataPrefix: string | null;
  createdAt: Date;
}

export type AirlineSummary = Pick<Airline, "id" | "iataCode" | "name" | "logoUrl">;
