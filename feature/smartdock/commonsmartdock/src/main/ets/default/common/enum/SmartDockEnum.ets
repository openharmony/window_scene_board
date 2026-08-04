/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 */

/**
 * Dock区域类型
 */
export const enum DockRegionType {
  RESIDENT = 'resident', // 常驻区
  RECENT = 'recent', // 最近任务区
  COLLABORATION = 'collaboration', // 多屏协同区
  OTHER = 'other', // 其它（用于DT）
}

/**
 * 应用状态
 */
export const enum AppStateType {
  PREPARE, /** 应用准备初始化 **/
  INIT, /**应用完成初始化 **/
  FOREGROUND, /** 应用在前台 **/
  FOCUS, /** 应用获焦 **/
  BACKGROUND, /** 应用在后台 **/
  EXIT /** 应用退出 **/
}