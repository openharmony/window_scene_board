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

import { HashMap } from '@kit.ArkTS';

// 标识节日缩写
export class FestivalAbbreviation {
  private festivalAbbreviationMap: HashMap<string, string> = new HashMap();
  private static instance: FestivalAbbreviation;

  constructor() {
    this.init();
  }

  static getInstance(): FestivalAbbreviation {
    if (!FestivalAbbreviation.instance) {
      FestivalAbbreviation.instance = new FestivalAbbreviation();
    }
    return FestivalAbbreviation.instance;
  }

  private init() {
    this.festivalAbbreviationMap.set('澳门回归纪念日', '澳门回归');
    this.festivalAbbreviationMap.set('中国人民警察节', '警察节');
    this.festivalAbbreviationMap.set('消费者权益日', '消费者日');
    this.festivalAbbreviationMap.set('中国人民抗日战争胜利纪念日', '抗战胜利');
    this.festivalAbbreviationMap.set('国家公祭日', '公祭日');
    this.festivalAbbreviationMap.set('九一八事变', '九一八');
    this.festivalAbbreviationMap.set('中国烈士纪念日', '烈士纪念');
    this.festivalAbbreviationMap.set('日本投降日', '日本投降');
    this.festivalAbbreviationMap.set('辛亥革命纪念日', '辛亥革命');
    this.festivalAbbreviationMap.set('抗美援朝纪念日', '抗美援朝');
  }

  /**
   * 是否包含节假日
   *
   * @param holiday 节假日
   * @returns 返回是否包含指定节假日
   */
  public hasHoliday(holiday: string): boolean {
    return this.festivalAbbreviationMap.hasKey(holiday);
  }

  /**
   * 获取简写节假日的名称
   *
   * @param holiday 节假日全称
   * @returns 简写后的节假日名称
   */
  public getHolidayName(holiday: string): string {
    return this.festivalAbbreviationMap.get(holiday) ?? '';
  }

}