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
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/bean/CardItemInfo';
import type { LauncherCardInfo } from './LauncherCardInfo';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';

/**
 * 桌面曝光数据
 *
 * @since 2023-10-08
 */
export class LauncherExposeEventLogs {
  /**
   * 服务推荐ID
   */
  public recId: string = '';
  /**
   * 一次服务推荐ID下的子ID，如局部替换后的半流程推荐
   */
  public subRecId: number = 0;
  /**
   * 曝光卡片的FormID
   */
  public formId: string = '';
  /**
   * 曝光开始时间
   */
  public startTime: number = 0;
  /**
   * 曝光结束时间
   */
  public endTime: number = 0;
  public portfolioId: string = '';
  /**
   * 曝光的屏幕状态（portrait：竖屏；landscape：横屏；expand：展开态
   */
  public orientation: string;
  public cardDimension: number;

  constructor(cardId: string) {
    this.formId = cardId;
    const parentForm: LauncherCardInfo | undefined = AbilityFormUtil.findParentFormByFormId(cardId);
    if (parentForm) {
      this.recId = parentForm.recId;
      this.subRecId = parentForm.subRecId;
      this.portfolioId = parentForm.portfolioInfo?.portfolioId ?? '';
    }
    const cardItem = AbilityFormUtil.getAiSuggestionItemByCardId(cardId);
    this.cardDimension = CardItemInfo.getCardDimension(cardItem?.area);
    this.startTime = Date.now();
    this.orientation = AbilityFormUtil.getScreenDisplayStatus();
  }
}