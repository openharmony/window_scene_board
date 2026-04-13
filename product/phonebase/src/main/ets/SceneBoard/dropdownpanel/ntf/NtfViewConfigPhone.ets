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
import { NtfBrightnessMode, NtfListContentConfig } from '@ohos/notificationcomponent/src/main/ets/vm/config/NtfViewConfig';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { NTF_BRIGHTENS_CENTRALIZED } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';

/**
 * 列表预加载个数(PAD)
 */
const LIST_CACHE_COUNT_PAD: number = 20;

export class NtfListContentConfigPhone extends NtfListContentConfig {
  constructor() {
    super();
    this.outerHeightOfNCAndCC = this.ntfListDefaultHeight;
    this.extraGeometryTransitionId = 'NotificationListContent';
    this.clipParam = false;
    if (DeviceHelper.isPad() || NTF_BRIGHTENS_CENTRALIZED) {
      // 由于性能问题，PCE等Pad产品，提亮统一在模糊合并组件上面配置。
      this.brightnessMode = NtfBrightnessMode.Centralized;
      // PAD产品使用独立的列表缓存数量, 提升通知列表滑动性能
      this.cachedCount = LIST_CACHE_COUNT_PAD;
    }
  }
}
