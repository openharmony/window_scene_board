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
import { AppIconDefaultModifier } from '../../launchericon/interface/AppIconDefaultModifier';

/**
 * 目前用于屏蔽图标组件长按手势使文件夹能够整体拖拽
 */
export class BigFolderAppDefaultModifier extends AppIconDefaultModifier {
  public callback?: (instance: CommonAttribute) => void;

  initializeModifier(instance: CommonAttribute): void {
    super.initializeModifier(instance);
    if (this.callback) {
      this.callback(instance);
    }
    instance.onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult => {
      return gestureInfo.type === GestureControl.GestureType.LONG_PRESS_GESTURE ? GestureJudgeResult.REJECT :
      GestureJudgeResult.CONTINUE;
    })
  }
}