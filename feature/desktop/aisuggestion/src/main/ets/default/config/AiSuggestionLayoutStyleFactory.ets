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
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AiSuggestionLayoutStyle } from './AiSuggestionLayoutStyle';
import { AiSuggestionMinLayoutStyle } from './AiSuggestionMinLayoutStyle';
import { AiSuggestionMidLayoutStyle } from './AiSuggestionMidLayoutStyle';
import { AiSuggestionLargeLayoutStyle } from './AiSuggestionLargeLayoutStyle';

const TAG = 'AiSuggestionFormStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议卡片布局
 *
 * @since 2024-04-27
 */
export class AiSuggestionLayoutStyleFactory {

  static createLayoutStyle(itemInfo: GridLayoutItemInfo): AiSuggestionLayoutStyle {
    log.showInfo(`createLayoutStyle dimension=${itemInfo.cardDimension}, cardId=${itemInfo.cardId}`);
    if (itemInfo.cardDimension === CommonConstants.CARD_DIMENSION_2x2) {
      return new AiSuggestionMinLayoutStyle();
    } else if (itemInfo.cardDimension === CommonConstants.CARD_DIMENSION_2x4) {
      return new AiSuggestionMidLayoutStyle();
    } else {
      return new AiSuggestionLargeLayoutStyle();
    }
  }
}