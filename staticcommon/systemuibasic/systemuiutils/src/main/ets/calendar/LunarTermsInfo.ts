/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

export class LunarTermsInfo {
  mYear: number;
  mMonth: number;
  mDay: number;

  constructor(year: number, month: number, day: number) {
    this.mYear = year;
    this.mMonth = month;
    this.mDay = day;
  }

  /**
   * is same year
   *
   * @param year year
   * @return boolean
   */
  isSameYear(year: number): boolean {
    return this.mYear === year;
  }

  /**
   * is same month
   *
   * @param month month
   * @return boolean
   */
  isSameMonth(month: number): boolean {
    return this.mMonth === month;
  }

  /**
   * is same day
   *
   * @param day day
   * @return boolean
   */
  isSameDay(day: number): boolean {
    return this.mDay === day;
  }
}