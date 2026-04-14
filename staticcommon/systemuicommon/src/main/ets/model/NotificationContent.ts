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

import notificationManager from '@ohos.notificationManager';
import type image from '@ohos.multimedia.image';
import type { WantAgent } from '@kit.AbilityKit';

/**
 * 通知角色
 */
export enum NotificationRole {
  /**
   * 单通知
   */
  NORMAL = 0,
  /**
   * 普通组通知
   */
  NORMAL_GROUP = 1,
  /**
   * 实况通知
   */
  LIVE_VIEW = 2,
}

/**
 * 通知分类
 */
export enum NotificationCategory {
  /**
   * 紧急消息
   */
  EMERGENCY = 10,

  /**
   * 实况
   */
  LIVE_VIEW = 20,

  /**
   * 置顶
   */
  PIN_TOP = 30,

  /**
   * 用增上半区置顶
   */
  CAMPAIGN_MAIN_TOP = 35,

  /**
   * 普通分类
   */
  NORMAL = 40,

  /**
   * 用增下半区置顶
   */
  CAMPAIGN_MORE_TOP = 998,

  /**
   * 其他通知
   */
  OTHER = 999,
}

/**
 * 通知创建者类型
 */
export enum NotificationCreatorType {
  APP = 0,
  PROXY_APP = 1,
  SA = 2,
}

/**
 * 实况卡片overlay图标样式
 */
export enum OverlayIconStyle {
  /**
   * 圆形
   */
  CIRCLE = 0,

  /**
   * 方形
   */
  SQUARE = 1,

  /**
   * 样式反转
   */
  REVERSE = 2,
}

/**
 * 通知action按钮数据
 */
export class NotificationAction {
  /**
   * 按钮标题
   */
  actionTitle: string;

  /**
   * 按钮点击事件调用远程
   */
  wantAgent: WantAgent;

  /**
   * 用户输入时标示
   */
  userInputKey?: string;

  /**
   * 更新计数值
   */
  updateCount: number;

  /**
   * 构造
   *
   * @param action 原action
   */
  constructor(action: notificationManager.NotificationActionButton) {
    this.actionTitle = action.title;
    this.wantAgent = action.wantAgent;
    this.userInputKey = action.userInput?.inputKey;
    this.updateCount = 0;
  }

  /**
   * 设置更新计数值
   *
   * @param count 计数值
   */
  setUpdateCount(count: number): void {
    this.updateCount = count;
  }

  /**
   * 获取更新计数值
   *
   * @return 更新计数值
   */
  getUpdateCount(): number {
    return this.updateCount;
  }
}

/**
 * 通知基础类型内容
 */
export class NotificationBaseContent {
  /**
   * 通知内容标题
   */
  contentTitle: string;

  /**
   * 通知内容
   */
  contentText: string;

  /**
   * 次要内容，通知头部subText
   */
  additionalText: string;

  /**
   * 通知内容概要
   * 分组通知收起时展示概要
   */
  briefText: string;

  /**
   * 通知展开时的内容标题
   */
  expandedTitle: string;

  /**
   * 通知展开时的内容文本
   */
  expandedContentText: string;

  /**
   * 通知底部大图片
   */
  bigPicture: image.PixelMap;

  /**
   * 构造
   *
   * @param baseContent 原数据
   */
  constructor(baseContent: notificationManager.NotificationBasicContent) {
    this.contentTitle = baseContent?.title?.trim() ?? '';
    this.contentText = baseContent?.text?.trim() ?? '';
    this.additionalText = baseContent?.additionalText?.trim() ?? '';
    // 展开时保持一致
    this.expandedTitle = this.contentTitle;
    this.expandedContentText = this.contentText;
    // 分组收起概要
    this.briefText = this.contentText;
  }
}

/**
 * 通知长文本类型内容
 */
export class NtfLongTextContent extends NotificationBaseContent {
  /**
   * 通知长文本内容
   */
  longText: string;

  /**
   * 构造
   *
   * @param longTextContent 原数据
   */
  constructor(longTextContent: notificationManager.NotificationLongTextContent) {
    super(longTextContent);
    this.longText = longTextContent?.longText?.trim() ?? '';
    this.briefText = longTextContent?.briefText?.trim() ?? '';
    this.expandedTitle = longTextContent?.expandedTitle?.trim() ?? '';
    this.expandedContentText = this.longText;
    // 展开时，优先使用展开文本
    if (!this.expandedTitle) {
      this.expandedTitle = this.contentTitle;
    }
    if (!this.expandedContentText) {
      this.expandedContentText = this.contentText;
    }
    // 分组收起概要
    if (!this.briefText) {
      this.briefText = this.contentText;
    }
  }
}

/**
 * 通知多行文本类型内容
 */
export class NtfMultiLineContent extends NotificationBaseContent {
  /**
   * 通知多行文本内容
   */
  linesText: Array<string>;

  // TODO 切换 SDK20 之后，删除掉下面的ts-ignore
  // @ts-ignore
  // 榜单置顶通知 wantAgents 属性数组
  // lineWantAgents: localWantAgent[] = [];

  /**
   * 构造
   *
   * @param multiLineContent 原数据
   */
  constructor(multiLineContent: notificationManager.NotificationMultiLineContent) {
    super(multiLineContent);
    this.linesText = multiLineContent?.lines ?? [];
    this.briefText = multiLineContent?.briefText?.trim() ?? '';
    this.expandedTitle = multiLineContent.longTitle?.trim() ?? '';
    this.expandedContentText = '';
    // TODO 切换 SDK20 之后，删除掉下面的ts-ignore
    // @ts-ignore
    this.lineWantAgents = multiLineContent?.lineWantAgents;

    // 展开时，优先使用展开文本
    if (!this.expandedTitle) {
      this.expandedTitle = this.contentTitle;
    }
    if (!this.linesText?.length) {
      this.expandedContentText = this.contentTitle;
    } else {
      let len = this.linesText.length;
      if (this.expandedContentText) {
        // 第一行内容添加换行
        this.expandedContentText += '\n';
      }
      for (let i = 0; i < len; i++) {
        this.expandedContentText += this.linesText[i]?.trim();
        if (i !== len - 1) {
          this.expandedContentText += '\n';
        }
      }
    }
    // 分组收起概要
    if (!this.briefText) {
      this.briefText = this.contentText;
    }
  }
}

/**
 * 通知图片类型内容
 */
export class NtfPictureContent extends NotificationBaseContent {
  /**
   * 构造
   *
   * @param picContent 原数据
   */
  constructor(picContent: notificationManager.NotificationPictureContent) {
    super(picContent);
    this.bigPicture = picContent?.picture;
    this.briefText = picContent?.briefText?.trim() ?? '';
    this.expandedTitle = picContent?.expandedTitle?.trim() ?? '';
    // 展开时，优先使用展开文本
    if (!this.expandedTitle) {
      this.expandedTitle = this.contentTitle;
    }
    this.expandedContentText = this.contentText;
    // 分组收起概要
    if (!this.briefText) {
      this.briefText = this.contentText;
    }
  }
}