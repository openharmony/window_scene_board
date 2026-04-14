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

import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CardItemInfo } from '../bean/CardItemInfo';

/**
 * 基本数据类型转换工具类
 */
export class ConvertUtil {
  /**
   * GridLayoutItemInfo转化成CardItemInfo
   */
  public static gridLayoutToCard(gridLayout: GridLayoutItemInfo): CardItemInfo {
    let card: CardItemInfo = new CardItemInfo();
    card.cardId = gridLayout.cardId ?? '';
    card.bundleName = gridLayout.bundleName;
    card.abilityName = gridLayout.abilityName;
    card.moduleName = gridLayout.moduleName ?? '';
    card.cardName = gridLayout.cardName ?? '';
    card.isTransparent = gridLayout.isTransparent ?? false;
    card.formConfigAbility = gridLayout.formConfigAbility;
    card.appLabelId = gridLayout.appLabelId;
    card.area = gridLayout.area;
    card.page = gridLayout.page;
    card.column = gridLayout.column;
    card.row = gridLayout.row;
    card.extend1 = gridLayout.extend1;
    card.extend2 = gridLayout.extend2;
    card.cardDimension = CardItemInfo.getCardDimension(gridLayout.area  ?? []);
    card.intent = gridLayout.intent;
    card.gameCardInfo = gridLayout.gameCardInfo;
    card.isFormDimension1x4 = gridLayout.isFormDimension1x4 ?? false;
    return card;
  }
}