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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { BaseDragHandler } from '../../../../../../../main/ets/service/drag/BaseDragHandler';
import { DragArea } from '../../../../../../../main/ets/service/drag/DragArea';

/**
 * BaseDragHandler DT测试套
 */
export function BaseDragHandlerTest() {
  describe('BaseDragHandlerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('BaseDragHandlerTest_DragEffectArea', Level.LEVEL0, (): void => {
      let handler = new TestDragHandler();
      let area: DragArea = {
        left: 0,
        right: 2,
        top: 0,
        bottom: 2,
      };
      handler.setDragEffectArea(area);
      expect(handler.testGetDragEffectArea()).assertEqual(area);
      expect(handler.testIsDragEffectArea(1, 1)).assertTrue();
      expect(handler.testIsDragEffectArea(3, 3)).assertFalse();
      handler.setDragEffectArea(null);
      expect(handler.testIsDragEffectArea(1, 1)).assertFalse();
    })
  })
}

class TestDragHandler extends BaseDragHandler {
  protected getItemIndex(x: number, y: number): number {
    throw new Error('Method not implemented.');
  }

  public onDragStart(x?: number, y?: number): void {
    throw new Error('Method not implemented.');
  }

  public testGetDragEffectArea() {
    return super.getDragEffectArea();
  }

  public testIsDragEffectArea(x: number, y: number) {
    return super.isDragEffectArea(x, y);
  }
}