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
import { ResUtils } from '@ohos/windowscene';
import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG: string = 'EnterpriseSpaceIcon-StyleConfiguration';

export class EnterpriseSpaceIconStyle {
  public iconWidth: Length | Resource = $r('app.float.status_bar_enterprise_space_icon_width');
  public iconHeight: Length | Resource = $r('app.float.status_bar_enterprise_space_icon_height');
  public iconSize: string | number | Resource = $r('app.float.status_bar_enterprise_space_icon_size');
}

export default class StyleConfiguration {
  static getEnterpriseSpaceIconStyle(): EnterpriseSpaceIconStyle {
    const key: string = TAG + '-EnterpriseSpaceIcon';
    return CommonStyleManager.getStyle(key, EnterpriseSpaceIconStyle);
  }
}