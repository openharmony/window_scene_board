/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { NeedRenderSnapShotAnimConfig,
  SCBSessionEventId } from '@ohos/windowscene';

@Component
export struct SCBSceneSnapShot {
  @ObjectLink needRenderSnapShotAnimConfig: NeedRenderSnapShotAnimConfig;

  private isNeedImageAnimation(): boolean {
    return this.needRenderSnapShotAnimConfig.animActionId === SCBSessionEventId.EVENT_MAXIMIZE ||
      this.needRenderSnapShotAnimConfig.animActionId === SCBSessionEventId.EVENT_RECOVER ||
      this.needRenderSnapShotAnimConfig.animActionId === SCBSessionEventId.EVENT_MAXIMIZE_FLOATING ||
      this.needRenderSnapShotAnimConfig.animActionId === SCBSessionEventId.EVENT_SPLIT_PRIMARY ||
      this.needRenderSnapShotAnimConfig.animActionId === SCBSessionEventId.EVENT_SPLIT_SECONDARY;
  }

  build() {
    if (this.isNeedImageAnimation() && this.needRenderSnapShotAnimConfig.animSnapshot !== undefined) {
      Image(this.needRenderSnapShotAnimConfig.animSnapshot)
        .draggable(false)
        .syncLoad(true)
        .visibility(this.needRenderSnapShotAnimConfig.animVisible ? Visibility.Visible : Visibility.Hidden)
        .objectFit(ImageFit.Fill)
        .hitTestBehavior(HitTestMode.None)
        .opacity(this.needRenderSnapShotAnimConfig.animSceneAlpha)
        .clip(true)
        .size({ width: '100%', height: '100%' })
    }
  }
}