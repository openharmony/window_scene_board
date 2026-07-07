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
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { CardItemInfo } from '@ohos/launchercommon';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import type { StackInfo } from './StackInfo';

/**
 * 特定FA卡片在桌面分布情况
 *
 * @since 2023-10-10
 */
export class LauncherFormDistribution {
 public screenIndex: number = 0;

  public cellX: number = 0;

  public cellY: number = 0;

  public formId: string = '';

  public bundleName: string = '';

  public moduleName: string = '';

  public formName: string = '';

  public dimension: number = 0;

  public abilityName: string = '';

  public cardType: AiSuggestionUpdateConstants.CardType = AiSuggestionUpdateConstants.CardType.DEFAULT;

  public portfolioId: string = '';

  public cardUniqueTag: string = '';

  public stackInfo?: StackInfo;

  public static convert(itemInfo: GridLayoutItemInfo): LauncherFormDistribution {
    let formDistribution = new LauncherFormDistribution();
    formDistribution.screenIndex = itemInfo.page ?? -1;
    formDistribution.cellX = itemInfo.column ?? 0;
    formDistribution.cellY = itemInfo.row ?? 0;
    formDistribution.formId = itemInfo.cardId ?? '';
    formDistribution.bundleName = itemInfo.bundleName ?? '';
    formDistribution.moduleName = itemInfo.moduleName ?? '';
    formDistribution.formName = itemInfo.cardName ?? '';
    formDistribution.dimension = CardItemInfo.getCardDimension(itemInfo.area);
    formDistribution.abilityName = itemInfo.abilityName;
    const extra = ExtraData.getExtend1(itemInfo.extend1 ?? '');
    formDistribution.cardType = extra?.cardType ?? AiSuggestionUpdateConstants.CardType.DEFAULT;
    formDistribution.portfolioId = extra?.portfolioId ?? AiSuggestionConstants.PORTFOLIO_ID_DEFAULT;
    formDistribution.cardUniqueTag = extra?.cardUniqueTag ?? '';
    return formDistribution;
  }
}
