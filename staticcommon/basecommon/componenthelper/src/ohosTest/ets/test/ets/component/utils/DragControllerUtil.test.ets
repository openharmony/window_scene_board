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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level } from '@ohos/hypium';
import { dragControllerUtil, DragControllerParams } from '../../../../../../main/ets/utils/DragControllerUtil';
import { dragSnapshotHelper, SnapshotType } from '../../../../../../main/ets/utils/DragSnapshotHelper';
import dragController from '@ohos.arkui.dragController';
import image from '@ohos.multimedia.image';
import { DragEvent } from 'DragControllerParam';

export function DragControllerUtilTest() {
  describe('DragControllerUtilTest', (): void => {
    beforeAll((): void => {})
    beforeEach((): void => {})
    afterAll((): void => {})
    afterEach((): void => {})

    it('DragControllerUtil_executeDrag_test', Level.LEVEL0, async (): Promise<void> => {
      let itemKey: string = 'key';
      let params: DragControllerParams = {
        key: [itemKey],
        dragStartCallback: () => {},
        dragEndCallback: () => {},
      };
      let res1 = await dragControllerUtil.executeDrag(params, 0, 0);
      expect(res1).assertFalse();
      params.dragItemInfo = [{}];
      let res2 = await dragControllerUtil.executeDrag(params, 0, 0);
      expect(res2).assertFalse();
      params.dragInfo = { pointerId: 0 };
      let res3 = await dragControllerUtil.executeDrag(params, 0, 0);
      expect(res3).assertFalse();
      params.dragInfo.touchPoint = { x: 0, y: 0 };
      let res4 = await dragControllerUtil.executeDrag(params, 0, 0);
      expect(res4).assertFalse();

      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions = {
        editable: true,
        pixelFormat: 3,
        size: { height: height, width: width }
      };
      let pixelMap : image.PixelMap = image.createPixelMapSync(color, opts);
      dragSnapshotHelper.setSnapshot(pixelMap, SnapshotType.DRAG, itemKey);
      let res5 = await dragControllerUtil.executeDrag(params, 0, 0);
      expect(res5).assertFalse();
    })

    it('DragControllerUtil_dragStatusChange_test', Level.LEVEL0, (): void => {
      let res: number = 0;
      let params: DragControllerParams = {};
      let info: dragController.DragAndDropInfo = {
        status: dragController.DragStatus.STARTED,
        event: {} as DragEvent,
      }
      dragControllerUtil.dragStatusChange(info, params, 0, 0);
      params.dragStartCallback = () => { res++ };
      dragControllerUtil.dragStatusChange(info, params, 0, 0);
      expect(res).assertEqual(1);

      info.status = dragController.DragStatus.ENDED;
      dragControllerUtil.dragStatusChange(info, params, 0, 0);
      params.dragEndCallback = () => { res-- };
      dragControllerUtil.dragStatusChange(info, params, 0, 0);
      expect(res).assertEqual(0);
    })
  })
}