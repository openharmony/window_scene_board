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

export default class Constants {
  public static readonly LOTTIE_DATA_OPEN: string = 'location_open.json';
  public static readonly LOTTIE_DATA_CLOSE: string = 'location_close.json';
  public static readonly LOTTIE_DATA_CLOSE_DARK: string = 'location_close_dark.json';
  public static readonly LOTTIE_DATA_OPEN_DARK: string = 'location_open_dark.json';

  public static readonly NEW_LOTTIE_DATA_OPEN: string = '01location_black_on.json';
  public static readonly NEW_LOTTIE_DATA_CLOSE: string = '02location_black_off.json';
}

export class StatusBarAnimateLocationData {
  public isShow: boolean = false; // 隐私新接口是否调用位置信息
  public isReOpen: boolean = false; // 是否5秒内重复调用
}