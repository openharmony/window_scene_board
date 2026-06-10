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
import { Hole } from '../vm/CutoutVm'

/**
 * 状态栏实况胶囊位置信息
 */
@ObservedV2
export class StatusBarCapsulePosition {
  /**
   * 左上角X
   */
  @Trace public left: number = 0;
  /**
   * 左上角Y
   */
  @Trace public top: number = 0;

  /**
   * 胶囊左侧允许的最大start(横向时间)
   */
  @Trace public capsuleLeftMax: number = 0;

  /**
   * 胶囊左侧允许的最小start(占用时间)
   */
  @Trace public capsuleLeftMinWithoutTime: number = 0;
  /**
   * 胶囊左侧允许的最小start(不占用时间)
   */
  @Trace public capsuleLeftMin: number = 0;
  /**
   * 胶囊右侧允许的最大end
   */
  @Trace public capsuleRightMax: number = 0;

  /**
   * 胶囊右侧所有空间的最大end
   */
  @Trace public capsuleRightAllMax: number = 0;
  /**
   * 宽度
   */
  @Trace public width: number = 0;
  /**
   * 高度
   */
  @Trace public height: number = 0;
  /**
   * 中间挖孔圆点列表
   */
  @Trace public holes: Hole[] = [];
  /**
   * 状态栏时间左侧间隔
   */
  @Trace public statusBarClockLeftSpace: number = 0;
}