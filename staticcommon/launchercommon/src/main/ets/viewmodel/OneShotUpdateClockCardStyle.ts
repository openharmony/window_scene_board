/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';

const TAG = 'OneShotUpdateClockCardStyle';
const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';
const CLOCK_WEATHER_BUNDLE_NAME: string = 'com.ohos.totemweather';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OneShotUpdateClockCardStyle {
  private static mInstance: OneShotUpdateClockCardStyle;
  private clockStyle: string = '';

  static getInstance(): OneShotUpdateClockCardStyle {
    if (!OneShotUpdateClockCardStyle.mInstance) {
      OneShotUpdateClockCardStyle.mInstance = new OneShotUpdateClockCardStyle();
    }
    return OneShotUpdateClockCardStyle.mInstance;
  }
  
  /**
   * 设置卡片的时钟样式
   *
   */
  setClockStyle(styleParam: string): void {
    this.clockStyle = styleParam;
  }
  
  /**
   * 获取卡片的时钟样式
   *
   * @returns 卡片的时钟样式
   */
  getClockStyle(cardName: string, bundleName: string): string | undefined {
    log.showInfo(`getClockStyle + cardName: ${cardName}`);
    return (bundleName === CLOCK_WEATHER_BUNDLE_NAME) ?
    this.clockStyle : undefined;
  }
}
