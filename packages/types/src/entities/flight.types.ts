import { CabinClass, FlightType } from "../common/enums";
import { AirportSummary } from "./airport.types";
import { AirlineSummary } from "./airline.types";

export interface Flight {
  id: string;
  flightNumber: string;
  airlineId: string;
  originId: string;
  destinationId: string;
  departureTime: Date;
  arrivalTime: Date;
  durationMinutes: number;
  stops: number;
  aircraftType: string | null;
  isCodeshare: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface FlightPrice {
  id: string;
  flightId: string;
  priceBrl: number;
  priceUsd: number | null;
  milesRequired: number | null;
  milesProgram: string | null;
  milePriceBrl: number | null;
  cabinClass: CabinClass;
  availableSeats: number | null;
  bagageIncluded: boolean;
  baggageAllowanceKg: number | null;
  taxes: number;
  validUntil: Date | null;
  scrapedAt: Date;
}

export interface FlightWithDetails extends Flight {
  airline: AirlineSummary;
  origin: AirportSummary;
  destination: AirportSummary;
  prices: FlightPrice[];
}

export interface FlightSearchParams {
  origin: string;         // IATA code
  destination: string;    // IATA code
  departureDate: string;  // YYYY-MM-DD
  returnDate?: string;    // YYYY-MM-DD (round trip)
  passengers: number;
  cabinClass?: CabinClass;
  flightType?: FlightType;
  directOnly?: boolean;
}

export interface FlightSearchResult {
  flights: FlightWithDetails[];
  searchId: string;
  searchedAt: Date;
  totalResults: number;
}
