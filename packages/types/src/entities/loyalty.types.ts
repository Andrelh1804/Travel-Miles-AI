import { LoyaltyProgramType } from "../common/enums";

export interface LoyaltyProgram {
  id: string;
  name: string;
  shortName: string;
  airlineId: string | null;
  programType: LoyaltyProgramType;
  logoUrl: string | null;
  pointsPerMile: number;
  expirationMonths: number | null;
  transferPartners: string[];
  isActive: boolean;
  createdAt: Date;
}

export interface MilesAccount {
  id: string;
  userId: string;
  loyaltyProgramId: string;
  accountNumber: string | null;
  balanceMiles: number;
  expirationDate: Date | null;
  lastUpdatedAt: Date;
  createdAt: Date;
}

export interface MilesAccountWithProgram extends MilesAccount {
  program: LoyaltyProgram;
  estimatedValueBrl: number;
}
