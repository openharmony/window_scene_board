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

import type ResMgr from '@ohos.resourceManager';
import NtfMgr from '@ohos.notificationManager';
import image from '@ohos.multimedia.image';

/**
 * 普通通知信息
 */
export interface INormalNtf {
  /**
   * 通知唯一标识
   */
  hashCode: string;

  /**
   * 通知小图标
   */
  overlayIcon: image.PixelMap;

  /**
   * 通知自定义图标
   */
  smallIcon: image.PixelMap;

  /**
   * 创建通知的应用的包名
   */
  creatorBundleName: string;

  /**
   * 是否隐藏通知内容
   */
  isHideContent: boolean;

  /**
   * 通知内容
   */
  notificationContent?: NotificationBaseContent;

  /**
   * 通知分组组名
   */
  groupName: string;

  /**
   * 模板通知的模板信息
   */
  template: NtfMgr.NotificationTemplate;

  /**
   * 是否是通知
   */
  isDeliverNotification: boolean;

  /**
   * 通知名称资源id
   */
  deliverLabelId: number;

  /**
   * 通知头标签，资源id
   */
  labelRes: ResMgr.Resource;

  /**
   * 获取通知分组标识
   *
   */
  getGroupKey: () => string;

  /**
   * 通知图标
   *
   * @returns
   */
  getDeliverAppIcon: () => number;

  /**
   * 普通通知图标
   *
   * @returns
   */
  getAppIconRes: () => ResMgr.Resource;

  /**
   * 是否为下载模板通知
   *
   * @return true 下载模板通知
   */
  isDownloadTemplate: () => boolean;

  /**
   * 获取应用名称资源
   *
   * @return app nameId
   */
  getDeliverAppName: () => number;

  /**
   * 获取label res
   *
   * @return label res
   */
  getLabelRes: () => ResMgr.Resource;
}

/**
 * 通知基础类型内容
 */
interface NotificationBaseContent {
  /**
   * 通知内容标题
   */
  contentTitle: string;

  /**
   * 通知内容
   */
  contentText: string;
}