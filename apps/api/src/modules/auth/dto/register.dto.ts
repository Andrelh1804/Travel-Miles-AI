import { IsEmail, IsString, MinLength, MaxLength, IsOptional, Matches } from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class RegisterDto {
  @ApiProperty({ example: "João Silva" })
  @IsString()
  @MinLength(2, { message: "O nome deve ter pelo menos 2 caracteres" })
  @MaxLength(100)
  name!: string;

  @ApiProperty({ example: "joao@example.com" })
  @IsEmail({}, { message: "E-mail inválido" })
  email!: string;

  @ApiProperty({ example: "SenhaSegura@123", minLength: 8 })
  @IsString()
  @MinLength(8, { message: "A senha deve ter pelo menos 8 caracteres" })
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, {
    message: "A senha deve conter letras maiúsculas, minúsculas e números",
  })
  password!: string;

  @ApiPropertyOptional({ example: "+5511999999999" })
  @IsOptional()
  @IsString()
  phoneNumber?: string;
}

export class ForgotPasswordDto {
  @ApiProperty({ example: "usuario@example.com" })
  @IsEmail({}, { message: "E-mail inválido" })
  email!: string;
}

export class ResetPasswordDto {
  @ApiProperty()
  @IsString()
  @MinLength(8)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, {
    message: "A senha deve conter letras maiúsculas, minúsculas e números",
  })
  password!: string;
}
