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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import SuperPrivacyConstants from '@ohos/superprivacycomponent/src/main/ets/com/ohos/common/Constants';

const TAG = 'ScreenLock-SuperPrivacyIcon';
const COMPONENT_ID_SUPER_PRIVACY_PADDLE = TAG + '_Image_super_privacy_paddle';
const COMPONENT_ID_SUPER_PRIVACY_SOFT = TAG + '_Image_super_privacy_soft';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CONTENT_COLOR_WHITE: string = '#FFFFFF';

@Component
export default struct ScreenLockSuperPrivacyIcon {
  @Consume contentColor: string;

  getId() {
    return SuperPrivacyConstants.IS_PADDLE_DEVICE ? COMPONENT_ID_SUPER_PRIVACY_PADDLE : COMPONENT_ID_SUPER_PRIVACY_SOFT;
  }

  private getShadow(): ShadowOptions[] | undefined {
    return this.contentColor === CONTENT_COLOR_WHITE ?
      [{
        radius: 2,
        color: '#33000000',
        offsetY: 1
      },
        {
          radius: 6,
          color: '#33000000',
          offsetY: 2
        }] : undefined;
  }

  build() {
    Text() {
      SymbolSpan($r('sys.symbol.key_shield_fill'))
        .draggable(false)
        .fontSize(`${vp2px(20)}px`)
        .fontColor([this.contentColor])
        .fontWeight(FontWeight.Medium)
    }
    .id(this.getId())
    .textShadow(this.getShadow())
  }
}