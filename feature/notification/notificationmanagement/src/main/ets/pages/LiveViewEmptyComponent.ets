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

import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';

const TAG: string = 'LiveViewEmptyComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 实况窗缺省页面组件
 */
@Component
export struct LiveViewEmptyComponent {
  @Link isCurrentApp: boolean;

  build() {
    Column() {
      Image($r('app.media.empty_live_view'))
        .width('120vp')
        .height('120vp')
        .draggable(false)
      Text($r('app.string.live_view_no_apps'))
        .fontColor($r('sys.color.font_secondary'))
        .fontSize('14fp')
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({
      bottom: ContextManager.aiBarHeightByVp
    })
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }
}
