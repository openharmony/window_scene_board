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
import FormAniItem from './FormAniItem';
import { ScreenLockFormAniData } from './ScreenLockFormAniData';
import { screenLockAniMgr, ScreenLockAniScene } from './ScreenLockFormAniMgr';

@Component
export struct ScreenLockFormAni {
  private scene: ScreenLockAniScene = ScreenLockAniScene.INNER;
  @State formDataArray: ScreenLockFormAniData[] = [];

  aboutToAppear(): void {
    screenLockAniMgr.aniDataArrayMap.set(this.scene, this.formDataArray);
  }

  aboutToDisappear(): void {
    screenLockAniMgr.aniModelMap.delete(this.scene);
  }

  build() {
    if (this.formDataArray.length > 0) {
      Stack({ alignContent: Alignment.TopStart }) {
        ForEach(this.formDataArray, (item: ScreenLockFormAniData) => {
          FormAniItem({
            data: item,
            scene: this.scene
          })
        }, (item: ScreenLockFormAniData) => item.id)
      }.hitTestBehavior(HitTestMode.Transparent)
    }
  }
}