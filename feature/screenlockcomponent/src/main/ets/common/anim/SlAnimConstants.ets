/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * 锁屏首页动画场景
 */
export enum SlAnimScene {
  SCENE_AUTH_SUCCESS = 'auth_success', // 人脸、指纹认证成功解锁动效
  SCENE_NOT_PWD_UNLOCK = 'not_pwd_unlock', // 无密码解锁动效
  SCENE_SLID_TO_PWD = 'slid_to_pwd', // 滑动进入密码输入页面动效
  SCENE_SLID_TOUCHING = 'slid_touching', // 跟手滑动解锁动效
  SCENE_TOOLS_USING = 'tools_using', // 锁屏小工具使用中
}