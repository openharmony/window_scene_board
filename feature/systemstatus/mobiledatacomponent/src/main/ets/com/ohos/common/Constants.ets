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
import { SimType } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubSimGetLabel';

export default class Constants {
  public static readonly LOTTIE_DATA_OPEN: string = 'mobiledata_open.json';
  public static readonly LOTTIE_DATA_CLOSE: string = 'mobiledata_close.json';
  public static readonly LOTTIE_DATA_OPEN_DARK: string = 'mobiledata_open_dark.json';
  public static readonly LOTTIE_DATA_CLOSE_DARK: string = 'mobiledata_close_dark.json';

  public static readonly NEW_LOTTIE_DATA_OPEN: string = '01mobiledata_black_on.json';
  public static readonly NEW_LOTTIE_DATA_CLOSE: string = '02mobiledata_black_off.json';
}

export class MobileDataData {
  public currentSimSlot: number = 0;
  public currentSimType: SimType = SimType.PSIM;
  public actualSimCount: number = 0;
  public isAirplaneMode: boolean = false;
}