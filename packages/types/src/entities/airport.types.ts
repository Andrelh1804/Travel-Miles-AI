export interface Airport {
  id: string;
  iataCode: string;
  icaoCode: string | null;
  name: string;
  city: string;
  state: string | null;
  country: string;
  countryCode: string;
  timezone: string;
  latitude: number;
  longitude: number;
  altitude: number | null;
  isActive: boolean;
  isMajor: boolean;
  createdAt: Date;
}

export type AirportSummary = Pick<Airport, "id" | "iataCode" | "name" | "city" | "country" | "countryCode">;
