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
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { RecentDelete } from './RecentDelete';

@Observed
export class RecentColorMode {

  /* 多任务一键删除提亮参数 */
  public themeAllClearButtonBgOptions: BrightnessOptions | undefined =
    RecentDelete.backgroundNineDarkOption;

  public themeAllClearButtonBgColor: ResourceColor = $r('app.color.ntf_phone_all_clear_bg_color');

}
