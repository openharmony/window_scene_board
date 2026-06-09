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

/**
 * 安装常量
 */
export class AppInstallConstants {
  public static readonly TYPE_ENTERPRISE = 'enterprise';
  public static readonly TYPE_INTERNALTESTING = 'internaltesting';
}

/**
 * 安装类型
 */
export enum InstallType {
  NEW_INSTALLER,
  UPDATER,
  ENTERPRISE_INSTALLER,
  ENTERPRISE_UPDATER,
  APP_CLONE,
}

/**
 * 事件名
 */
export enum AppGalleryEventStatus {
  /**
   * 创建任务
   */
  DOWNLOAD_CREATE_EVENT = 501,

  /**
   * 等待下载
   */
  DOWNLOAD_WAIT_EVENT = 502,

  /**
   * 暂停
   */
  DOWNLOAD_PAUSE_EVENT = 503,

  /**
   * 恢复下载
   */
  DOWNLOAD_RESUME_EVENT = 504,

  /**
   * WLAN预约
   */
  DOWNLOAD_WLAN_EVENT = 505,

  /**
   * 下载失败
   */
  DOWNLOAD_FAILED_EVENT = 506,

  /**
   * 下载成功
   */
  DOWNLOAD_SUCCEED_EVENT = 507,

  /**
   * 下载取消
   */
  DOWNLOAD_CANCEL_EVENT = 508,

  /**
   * 下载进度
   */
  DOWNLOAD_PROGRESS_EVENT = 509,

  /**
   * 开始安装
   */
  INSTALL_START_EVENT = 510,

  /**
   * 安装失败
   */
  INSTALL_FAILED_EVENT = 511,

  /**
   * 安装成功
   */
  INSTALL_SUCCEED_EVENT = 512,

  /**
   * 企业应用重置通知
   */
  COMPANY_APP_RESET_EVENT = 518,
}