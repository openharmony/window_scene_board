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

/**
 * 应用接续状态
 */
export class HiSysContinueStateData {
  public static readonly ACTIVE: string = 'active';
  public static readonly INACTIVE: string = 'inactive';
}

export class HiSysContinueFuncResult {
  public static readonly SUCCESS: number = 1;
  public static readonly FAIL: number = 2;
}

export class HiSysContinueSceneStageData {
  // 应用接续  常用场景阶段常量  场景2：桌面dock初始化
  public static readonly SCENE_SECOND: number = 2;
  // 应用接续  第二场景第一阶段 桌面dock向DMS注册接续通知回调
  public static readonly SCENE_SECOND_STAGE_FIRST: number = 1;
  // 应用接续  常用场景阶段常量  场景8：sink端接收获焦广播
  public static readonly SCENE_EIGHTH: number = 8;
  // 应用接续  第八场景第四阶段 dock收到DMS接续通知
  public static readonly SCENE_EIGHTH_STAGE_FOURTH: number = 4;
  // 应用接续  第八场景第四阶段 dock显示接续图标
  public static readonly SCENE_EIGHTH_STAGE_FIFTH: number = 5;
  // 应用接续  常用场景阶段常量  场景9：sink端接收失焦广播
  public static readonly SCENE_NINTH: number = 9;
  // 应用接续  第九场景第四阶段 dock收到DMS接续通知
  public static readonly SCENE_NINTH_STAGE_FOURTH: number = 4;
  // 应用接续  第九场景第五阶段 dock中接续图标消失
  public static readonly SCENE_NINTH_STAGE_FIFTH: number = 5;
  // 应用接续  常用场景阶段常量  场景10：sink端点击接续图标触发接续
  public static readonly SCENE_TENTH: number = 10;
  // 应用接续  第十场景第一阶段 点击dock中接续图标
  public static readonly SCENE_TENTH_STAGE_FIRST: number = 1;
  // 应用接续  第十场景第二阶段 dock触发接续流程
  public static readonly SCENE_TENTH_STAGE_SECOND: number = 2;
  // 应用接续  当前阶段是否处于一个场景的开头或结尾  开头1  结尾2
  public static readonly SCENE_START: number = 1;
  // 应用接续  当前阶段是否处于一个场景的开头或结尾  开头1  结尾2
  public static readonly SCENE_END: number = 2;
}