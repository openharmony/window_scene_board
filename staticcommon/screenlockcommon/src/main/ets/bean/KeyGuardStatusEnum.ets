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

export enum KeyGuardPage {
  // 默认锁屏主页面
  HOME_PAGE = 0,
  // 低指纹认证页面
  LOWE_FINGER_PAGE = 1,
  // 密码认证页面
  PWD_PAGE = 2,
  // sim卡认证页面
  SIM_PIN_PAGE = 3,
  // 远程锁定页面
  REMOTE_PAGE = 4,
  // 假AOD页面
  FAKE_AOD_PAGE = 5,
  // 紧急呼叫页面
  EMERGENCY_PAGE = 6,
  // 丢失模式页面
  LOST_MODE_PAGE = 7,
  // 主题编辑页面
  THEME_EDIT_PAGE = 8,
  // 热安全页面
  THERMAL_SAFETY_PAGE = 9,
  // 应急模式页面
  POWER_EMERGENCY_PAGE = 10,
  // 锁屏相机拉起页面
  CAMERA_PAGE = 11,
  // 锁屏计算器拉起页面
  CALCULATOR = 12,

  // 退出锁屏
  EXIT_PAGE = 100,
}

export enum KeyGuardMode {
  // 默认
  DEFAULT = 0,
  // sim卡锁定模式
  SIM_LOCK = 1 << 1,
  // 主题编辑模式
  THEME_EDIT = 1 << 2,
  // 仙人掌模式
  CACTUS = 1 << 3,
  // 强认证模式
  STRONG_AUTH = 1 << 4,
  // 丢失模式
  LOST_MODE = 1 << 5,
  // 热安全模式
  THERMAL_SAFETY = 1 << 6,
  // 应急模式
  POWER_EMERGENCY = 1 << 7,
  // 皮套模式
  LEATHER_COVER = 1 << 8,
  // 快速工具模式
  QUICK_TOOLS = 1 << 9,
  // 云端模式
  CLOUD_LAI = 1 << 10,
  // 云端模式二
  CLOUD_LAI_2 = 1 << 11,
}

export enum KeyGuardLockStatus {
  // 默认无认证方式
  DEFAULT = 0,
  // 已锁定
  LOCKING = 1,
  // 已解锁
  UNLOCKED = 2,
}

export enum KeyGuardCacheKey {
  // 锁屏遮蔽状态
  OCCLUDED_STATUS = 'KEYGUARD_OCCLUDED',
  // 锁屏锁定状态,取值 KeyGuardLockStatus
  LOCK_STATUS = 'KEYGUARD_LOCK_STATUS',
  // 锁屏页面类型,取值 KeyGuardPage
  PAGE_TYPE = 'KEYGUARD_PAGE_TYPE',
  // 认证类型
  AUTH_TYPE = 'KEYGUARD_AUTH_TYPE',
  // 认证子类型
  AUTH_SUBTYPE = 'KEYGUARD_AUTH_SUBTYPE',
  // 认证使能
  AUTH_ENABLE = 'KEYGUARD_AUTH_ENABLE',
  // 特殊模式,取值 KeyGuardMode
  SPECIAL_MODE = 'KEYGUARD_SPECIAL_MODE',
  // 设备折叠状态
  DEVICE_FOLD_STATUS = 'DEVICE_FOLD_STATUS',
  // 设备显示大小
  DEVICE_DISPLAY_SIZE = 'DEVICE_DISPLAY_SIZE',
  // 皮套模式
  COVER_MODE = 'KEYGUARD_COVER_MODEL',
  // 交互壁纸可滑动解锁
  INTERWALLPAPER_UNLOCKABLE = 'INTERWALLPAPER_UNLOCKABLE',
  // 锁屏问候模式
  SL_GREET_MODE = 'SL_GREET_MODE',
}

export enum KeyguardCoverModel {
  // 非皮套模式
  COVER_REMOVED = 0,
  // 皮套模式
  COVER_ADDED_ON = 1,
}

export enum KeyguardSlGreetModel {
  // 关闭问候
  SL_GREET_OFF = 0,
  // 开启
  SL_GREET_ON = 1,
}

export enum WallpaperStratege {
  //不可交互壁纸
  DISABLE_TOUCHABLE = 0,
  //可交互壁纸,锁屏不能滑动
  ENABLE_TOUCHABLE_WITHOUT_KEYGUARD = 1,
  // 可交互壁纸,锁屏能滑动
  ENABLE_TOUCHABLE_WITH_KEYGUARD = 2
}