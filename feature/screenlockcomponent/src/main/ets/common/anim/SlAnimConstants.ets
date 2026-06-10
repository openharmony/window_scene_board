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
 * 锁屏首页动画场景
 */
export enum SlAnimScene {
  SCENE_AUTH_SUCCESS = 'auth_success', // 人脸、指纹认证成功解锁动效
  SCENE_NOT_PWD_UNLOCK = 'not_pwd_unlock', // 无密码解锁动效
  SCENE_SLID_TO_PWD = 'slid_to_pwd', // 滑动进入密码输入页面动效
  SCENE_SLID_TOUCHING = 'slid_touching', // 跟手滑动解锁动效
  SCENE_TOOLS_USING = 'tools_using', // 锁屏小工具使用中
}