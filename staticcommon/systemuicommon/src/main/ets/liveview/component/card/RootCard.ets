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

import { LiveViewData } from '../../data/LiveViewData';
import { LiveType, LiveUseScene } from '../../common/LiveConstants';
import { SystemCard } from './SystemCard';
import { LiveSystemTemplate } from '../../data/template/LiveSystemTemplate';
import { OtherBaseTemplate } from '../../data/template/OtherBaseTemplate';
import { OtherCard } from './OtherCard';
import { OtherNavigationCard } from './OtherNavigationCard';
import { LiveNavigationTemplate } from '../../data/template/LiveNavigationTemplate';

export interface RootCardParams {
  /**
   * 实况数据
   */
  data: LiveViewData;
  /**
   * 卡片使用场景
   */
  useScene: LiveUseScene;
  /**
   * 是否为沉浸式卡片
   */
  isImmersiveLive?: boolean;
  /**
   * 是否显示授权提示，仅在锁屏和通知中心显示
   */
  showAuthorizationTip?: boolean;
  /**
   * 触摸缩放参数
   */
  cardScale?: number;

  isNeedBannerInScreenLock?: boolean;
  isShowBannerFromScreenLock?: boolean;
  /**
   * 扩展新形态小外屏宽度
   */
  outerHomeFoldedWidth?: Length;
  /**
   * 扩展新形态小外屏缩放
   */
  outerHomeFoldedScale?: ScaleOptions;
}

@Builder
export function RootCard($$: RootCardParams) {
  if ($$.data) {
    if ($$.data?.liveType === LiveType.TYPE_SYSTEM && $$.data?.template instanceof LiveSystemTemplate) {
      SystemCard({
        baseData: $$.data,
        data: $$.data?.template as LiveSystemTemplate,
        useScene: $$.useScene,
        isNeedBannerInScreenLock: $$.isNeedBannerInScreenLock,
        isShowBannerFromScreenLock: $$.isShowBannerFromScreenLock
      })
        .width($$.outerHomeFoldedWidth)
        .scale($$.outerHomeFoldedScale)
    } else if (($$.data?.template as OtherBaseTemplate)?.layoutType === LiveType.NAVIGATION) {
      OtherNavigationCard({
        baseData: $$.data,
        data: $$.data?.template as LiveNavigationTemplate,
        timerData: ($$.data?.template as LiveNavigationTemplate)?.timer,
        useScene: $$.useScene,
        showAuthorizationTip: $$.showAuthorizationTip ?? false,
        cardScale: $$.cardScale,
        isNeedBannerInScreenLock: $$.isNeedBannerInScreenLock,
        isShowBannerFromScreenLock: $$.isShowBannerFromScreenLock
      }).width($$.outerHomeFoldedWidth)
        .scale($$.outerHomeFoldedScale)
    } else {
      OtherCard({
        baseData: $$.data,
        data: $$.data?.template as OtherBaseTemplate,
        timerData: ($$.data?.template as OtherBaseTemplate)?.timer,
        useScene: $$.useScene,
        isImmersiveLive: $$.isImmersiveLive ?? false,
        showAuthorizationTip: $$.showAuthorizationTip,
        isNeedBannerInScreenLock: $$.isNeedBannerInScreenLock,
        isShowBannerFromScreenLock: $$.isShowBannerFromScreenLock
      }).width($$.outerHomeFoldedWidth)
        .scale($$.outerHomeFoldedScale)
    }
  }
}