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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import { ImmersiveAnimInfo } from '../../../../../main/ets/model/data/anim/ImmersiveAnimInfo';
import { ImmersiveAnimStyle } from '../../../../../main/ets/model/data/anim/ImmersiveAnimStyle';


/**
 * 沉浸式锁屏状态管理测试用例
 */
export function ImmersiveAnimInfoTest01() {
  describe('ImmersiveAnimInfoTest01', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterAll((): void => {

    });
    afterEach((): void => {

    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

    it('test_constructor_01', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      expect(res).not().assertNull();
    });

    it('test_constructor_02', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res).not().assertNull();
    });

    it('test_constructor_03', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      expect(res).not().assertNull();
    });

    it('test_setComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle(), 'test');
      res.setComponentId('test_setComponentId');
      expect(res.getComponentId() === 'test_setComponentId').assertTrue();
    });

    it('test_getComponentId', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      expect(res.getComponentId() === '').assertTrue();
    });

    it('test_updateAreaWidth', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let componentArea: Area = {
        width: 0,
        height: 0,
        position: { x: 0, y: 0 },
        globalPosition: { x: 0, y: 0 }
      };
      res.setComponentArea(componentArea);
      res.updateAreaWidth(100);
      let newArea = res.getComponentArea() as Area;
      expect(newArea.width === 100).assertTrue();
    });

    it('test_getComponentPosition', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test', new ImmersiveAnimStyle());
      let newArea = res.getComponentPosition();
      expect(newArea).not().assertNull();
    });

    it('test_getComponentAnimStyle', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      let newArea = res.getComponentAnimStyle();
      expect(newArea).not().assertNull();
    });

    it('test_removeChildAnimInfo', Level.LEVEL0, (): void => {
      let res = new ImmersiveAnimInfo('test');
      res.removeChildAnimInfo('test');
      expect(true).assertTrue();
    });

  });
}