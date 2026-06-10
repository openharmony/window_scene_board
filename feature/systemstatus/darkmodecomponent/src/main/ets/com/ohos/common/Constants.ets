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

import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';

export default class Constants {
  public static readonly LOTTIE_DATA_OPEN: string = 'new_dark_mode.json';
  public static readonly LOTTIE_DATA_CLOSE: string = 'new_dark_mode.json';
  public static readonly LOTTIE_DATA_OPEN_DARK: string = 'new_dark_mode.json';
}

export class DarkModeData extends ToggleViewData {
  @Track public status: boolean = false;
}