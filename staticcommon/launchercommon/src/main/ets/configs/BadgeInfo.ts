/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

export class BadgeConfigure {
  public textWidth: number = 0;
  public textHeight: number = 0;
  public textFontSize: number = 0;
  public badgeDistanceIcon: number = 0;
}

const badgeInfo: Map<string, BadgeConfigure> = new Map([
  ['From1to9', {textWidth: 18, textHeight: 18, textFontSize: 12, badgeDistanceIcon: 6} as BadgeConfigure],
  ['From10to99', {textWidth: 26, textHeight: 18, textFontSize: 12, badgeDistanceIcon: 6} as BadgeConfigure],
  ['MoreThan99', {textWidth: 33, textHeight: 18, textFontSize: 12, badgeDistanceIcon: 6} as BadgeConfigure],
  ['InFolder1to9', {textWidth: 14, textHeight: 14, textFontSize: 10, badgeDistanceIcon: 3} as BadgeConfigure],
  ['InFolder10to99', {textWidth: 20, textHeight: 14, textFontSize: 10, badgeDistanceIcon: 3} as BadgeConfigure],
  ['InFolderMoreThan99', {textWidth: 26, textHeight: 14, textFontSize: 10, badgeDistanceIcon: 3} as BadgeConfigure],
  ['SimpleFrom1to9', {textWidth: 24, textHeight: 24, textFontSize: 20, badgeDistanceIcon: 8} as BadgeConfigure],
  ['SimpleFrom10to99', {textWidth: 35, textHeight: 24, textFontSize: 20, badgeDistanceIcon: 8} as BadgeConfigure],
  ['SimpleMoreThan99', {textWidth: 47, textHeight: 24, textFontSize: 20, badgeDistanceIcon: 8} as BadgeConfigure],
]);

export default badgeInfo;

export enum BadgeNumberType {
  BADGE_NUM_ZERO = 0,
  BADGE_NUM_NINE = 9,
  BADGE_NUM_NINETY_NINE = 99
}