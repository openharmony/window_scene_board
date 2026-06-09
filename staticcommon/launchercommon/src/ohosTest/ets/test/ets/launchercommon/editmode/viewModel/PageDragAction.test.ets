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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium"
import { PageDragAction } from "../../../../../../../main/ets/editmode/viewModel/PageDragAction"
import { image } from "@kit.ImageKit"
import sceneSessionManager from "@ohos.sceneSessionManager";

export function PageDragActionTest() {
  describe('PageDragActionTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_executeDrag', 0, async () => {
      const color = new ArrayBuffer(600*600*4);
      let opts: image.InitializationOptions = {
        editable: true,
        pixelFormat: image.PixelMapFormat.RGBA_8888,
        size: { height: 600, width: 600 }
      }
      const imageSrc = await image.createPixelMap(color, opts);
      const pageDragAction = new PageDragAction({
        dragItemImage: imageSrc,
        touchPoint: {
          x: 0,
          y: 0
        },
        imageRadius: 0,
        onDragStart: (): void => {},
        onDragEnd: (): void => {},
        onDragFinish: (): void => {},
        onDragCancel: (): void => {}
      });
      const res = await pageDragAction.executeDrag();
      expect(res).assertFalse();
    })

    it('test_executeDrag2', 0, async () => {
      const color = new ArrayBuffer(600*600*4);
      let opts: image.InitializationOptions = {
        editable: true,
        pixelFormat: image.PixelMapFormat.RGBA_8888,
        size: { height: 600, width: 600 }
      }
      const imageSrc = await image.createPixelMap(color, opts);
      const pageDragAction = new PageDragAction({
        dragItemImage: imageSrc,
        touchPoint: {
          x: 0,
          y: 0
        },
        imageRadius: 0,
        onDragStart: (): void => {},
        onDragEnd: (): void => {},
        onDragFinish: (): void => {},
        onDragCancel: (): void => {}
      });
      const ctx: UIContext = sceneSessionManager.getRootSceneUIContext();
      const res = await pageDragAction.executeDrag(ctx);
      expect(res).assertFalse();
    })
  })
}