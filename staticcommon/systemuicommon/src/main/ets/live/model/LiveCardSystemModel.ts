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

import { PhoneSimStatus } from '../../liveview/common/LiveConstants';
import { LiveCardModel } from './LiveCardModel';
import { LiveButtonModel, LiveCardType, LiveProgressModel, LiveTimerModel } from './LiveCommonModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 系统实况卡片数据
 */
export class LiveCardSystemModel extends LiveCardModel {
  readonly cardType: LiveCardType = LiveCardType.TYPE_SYSTEM;

  /**
   * 来电卡片SIM卡图标，默认不显示图标
   */
  simIconStatus?: PhoneSimStatus;
  /**
   * 卡片标题
   */
  title: string = '';
  /**
   * 卡片副文本
   */
  content: string = '';
  /**
   * 计时器数据
   */
  timer?: LiveTimerModel;
  /**
   * 计时器是否在标题显示
   */
  isTimerInTitle: boolean = true;
  /**
   * 按钮列表
   */
  buttons?: LiveButtonModel[];
  /**
   * 按钮优先级索引列表
   */
  buttonPriority?: number[];
  /**
   * 进度数据
   */
  progress?: LiveProgressModel;

  releaseImages(newCard?: LiveCardSystemModel): void {
    this.buttons?.forEach((icon, index) => {
      SystemUICommonUtil.releaseImage(icon.lightIcon, newCard?.buttons?.[index]?.lightIcon);
      SystemUICommonUtil.releaseImage(icon.darkIcon, newCard?.buttons?.[index]?.darkIcon);
    });
  }
}