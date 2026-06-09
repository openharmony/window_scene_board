/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// 4 -> 100
const UNFOLDED_IDENTIFIER: number = 4;

// 2 -> 010
const LAND_IDENTIFIER: number = 2;

// 1 -> 001
const DARK_IDENTIFIER: number = 1;

/**
 * Constants class for resource qualifier management
 *
 * @since 2023-03-15
 */
export class ResourceQualifierConstants {
  // default = folded-portrait-light = 000 = 0
  public static readonly IDX_DEFAULT: number = 0;

  // dark = folded-portrait-dark = 001 = 1
  public static readonly IDX_DARK: number = DARK_IDENTIFIER;

  // land = unfolded-landscape-light = 010 = 2
  public static readonly IDX_LAND: number = LAND_IDENTIFIER;

  // land_dark = folded-landscape-dark = 011 = 3
  public static readonly IDX_LAND_DARK: number = (DARK_IDENTIFIER | LAND_IDENTIFIER);

  // unfolded = unfolded-portrait-light = 100 = 4
  public static readonly IDX_UNFOLDED: number = UNFOLDED_IDENTIFIER;

  // unfolded_dark = unfolded-portrait-dark = 101 = 5
  public static readonly IDX_UNFOLDED_DARK: number = (DARK_IDENTIFIER | UNFOLDED_IDENTIFIER);

  // unfolded_land = unfolded-landscape-light = 110 = 6
  public static readonly IDX_UNFOLDED_LAND: number = (UNFOLDED_IDENTIFIER | LAND_IDENTIFIER);

  // unfolded_land_dark = unfolded-landscape-dark = 111 = 7
  public static readonly IDX_UNFOLDED_LAND_DARK: number = ((DARK_IDENTIFIER | UNFOLDED_IDENTIFIER) | LAND_IDENTIFIER);

  // unfolded2 = unfolded2-portrait-light = 1000 = 8
  public static readonly IDX_FULL_UNFOLDED: number = 8;

  // unfolded2-dark = unfolded2-portrait-dark = 1001 = 9
  public static readonly IDX_FULL_UNFOLDED_DARK: number = 9;

  // unfolded2-land = unfolded2-landscape-light = 1010 = 10
  public static readonly IDX_FULL_UNFOLDED_LAND: number = 10;

  // unfolded2-land-dark = unfolded2-landscape-dark = 1011 = 11
  public static readonly IDX_FULL_UNFOLDED_LAND_DARK: number = 11;

  // base
  public static readonly QUALIFIER_BASE: string = 'base';

  // unfolded
  public static readonly QUALIFIER_UNFOLDED: string = 'unfolded';

  // unfolded2
  public static readonly QUALIFIER_FULL_UNFOLDED: string = 'unfolded2';

  // land
  public static readonly QUALIFIER_LAND: string = 'land';

  // unfolded2-dark
  public static readonly QUALIFIER_FULL_UNFOLDED_DARK: string = `unfolded2-dark`;

  // unfolded2-land
  public static readonly QUALIFIER_FULL_UNFOLDED_LAND: string = `unfolded2-land`;

  // unfolded2-land-dark
  public static readonly QUALIFIER_FULL_UNFOLDED_LAND_DARK: string = `unfolded2-land-dark`;

  // card
  public static readonly QUALIFIER_FA: string = 'fa';

  // unfolded-land
  public static readonly QUALIFIER_UNFOLDED_LAND: string = `${this.QUALIFIER_UNFOLDED}-${this.QUALIFIER_LAND}`;

  // dark
  public static readonly QUALIFIER_DARK: string = 'dark';

  // dark-unfolded
  public static readonly QUALIFIER_UNFOLDED_DARK: string = `${this.QUALIFIER_UNFOLDED}-${this.QUALIFIER_DARK}`;

  // dark-land
  public static readonly QUALIFIER_LAND_DARK: string = `${this.QUALIFIER_LAND}-${this.QUALIFIER_DARK}`;

  // dark-unfolded-land
  public static readonly QUALIFIER_UNFOLDED_LAND_DARK: string =
    `${this.QUALIFIER_UNFOLDED_LAND}-${this.QUALIFIER_DARK}`;
}