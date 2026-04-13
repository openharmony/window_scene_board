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

import type { image } from '@kit.ImageKit';
import type { WantAgent } from '@kit.AbilityKit';
import { LiveCardModel } from './LiveCardModel';
import { LiveCardType, LiveExtensionType, LiveRichTextModel, LiveTimerModel } from './LiveCommonModel';
import { LayoutStyle } from '../../liveview/common/LiveConstants';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { NotificationAction } from '../../model/NotificationContent';

/**
 * 三方实况卡片数据基类
 */
export class LiveCardOtherModel extends LiveCardModel {
  readonly cardType: LiveCardType = LiveCardType.NO_LAYOUT;

  /**
   * 实况场景
   */
  event: string;
  /**
   * 模板子类型
   */
  style?: LayoutStyle;
  /**
   * 固定区标题
   */
  fixedTitle: string;
  /**
   * 固定区内容，支持富文本
   */
  fixedContent: LiveRichTextModel[];
  /**
   * 扩展区类型
   */
  extensionType: LiveExtensionType;
  /**
   * 辅助区显示的文本信息，仅当extensionType值为COMMON_TEXT或CAPSULE_TEXT时有效
   */
  extensionText?: string;
  /**
   * 辅助区显示的图片
   */
  extensionPic?: image.PixelMap;
  /**
   * 辅助区显示的图片路径
   */
  extensionPicRes?: string;
  /**
   * 辅助区点击动作
   */
  extensionWantAgent?: WantAgent;
  /**
   * 计时器数据
   */
  timer?: LiveTimerModel;
  /**
   * 是否显示授权提示
   */
  isShowAuthorization: boolean = false;
  /**
   * 关联服务按钮数组
   */
  serviceButtons: Array<NotificationAction> = [];

  releaseImages(newCard?: LiveCardOtherModel): void {
    SystemUICommonUtil.releaseImage(this.extensionPic, newCard?.extensionPic);
  }
}