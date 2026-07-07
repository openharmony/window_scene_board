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

import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { CardResourceInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/CardResourceInfo';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { AiSuggestionConstants, LongPressType } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

/**
 * 语音助手建议布局状态变量
 *
 * @since 2025-05-27
 */
@ObservedV2
export class AiSuggestionComponentData {
  @Trace public recItems: LauncherRecItem[] = [];
  @Trace public portfolioInfo: PortfolioInfo | undefined = undefined;
  @Trace public cardResourceInfo: CardResourceInfo = new CardResourceInfo();
  @Trace public launcherDisplayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
  @Trace public descPadding: Padding | undefined = undefined;
  @Trace public chipItemMargin: Margin | undefined = undefined;
  @Trace public iconRadius: number = 0;
  @Trace public formItemWidth: number = 0;
  @Trace public formItemHeight: number = 0;
  @Trace public portfolioPicUrl: string = '';
  @Trace public isArrivedTime: boolean = false;
  @Trace public gridPadding: number = 0;
  @Trace public iconSize: number = AiSuggestionConstants.ICON_DEFAULT_SIZE;
  @Trace public appGroupBgColor: ResourceColor = '';
  @Trace public desc2TopMargin: number = 0;
  @Trace public mUseEffect: boolean = false;
  public isUseEffectValue: boolean = false;
  public updateAppNameValue: string = '';
  @Trace public recItemCompId: string | undefined = 'default';
  @Trace public recItemCardsVisibility: Map<number, boolean> = new Map();
  @Trace public isFormSizeChange: boolean = false;
  @Trace public formPressType: LongPressType = LongPressType.DEFAULT;
  @Trace public backgroundColor: ResourceColor = '';
  public isItemSelected: boolean = false;
  public selectedItem: LauncherRecItem | undefined = new LauncherRecItem();
}
