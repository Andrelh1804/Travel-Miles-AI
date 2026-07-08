import { AlertType, NotificationChannel, CabinClass } from "../common/enums";
import { AirportSummary } from "./airport.types";
import { AirlineSummary } from "./airline.types";

export interface Alert {
  id: string;
  userId: string;
  type: AlertType;
  name: string | null;
  originId: string | null;
  destinationId: string | null;
  airlineId: string | null;
  loyaltyProgramId: string | null;
  maxPriceBrl: number | null;
  maxMiles: number | null;
  departureDateFrom: Date | null;
  departureDateTo: Date | null;
  cabinClass: CabinClass | null;
  channels: NotificationChannel[];
  isActive: boolean;
  lastTriggeredAt: Date | null;
  triggeredCount: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface AlertWithDetails extends Alert {
  origin: AirportSummary | null;
  destination: AirportSummary | null;
  airline: AirlineSummary | null;
}

export type CreateAlertDto = Omit<
  Alert,
  "id" | "userId" | "lastTriggeredAt" | "triggeredCount" | "createdAt" | "updatedAt"
>;

export interface Notification {
  id: string;
  userId: string;
  alertId: string | null;
  channel: NotificationChannel;
  title: string;
  body: string;
  data: Record<string, unknown> | null;
  sentAt: Date | null;
  readAt: Date | null;
  createdAt: Date;
}
