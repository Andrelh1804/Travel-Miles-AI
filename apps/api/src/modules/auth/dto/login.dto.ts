import { IsEmail, IsString, MinLength, IsOptional, IsBoolean } from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class LoginDto {
  @ApiProperty({ example: "usuario@example.com" })
  @IsEmail({}, { message: "E-mail inválido" })
  email!: string;

  @ApiProperty({ example: "SenhaSegura@123", minLength: 8 })
  @IsString()
  @MinLength(8, { message: "A senha deve ter pelo menos 8 caracteres" })
  password!: string;

  @ApiPropertyOptional({ description: "Manter sessão ativa" })
  @IsOptional()
  @IsBoolean()
  rememberMe?: boolean;
}
