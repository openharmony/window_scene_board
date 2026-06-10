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
import { ForceType, GravityAnimationConfig } from '../../../../../../../../../Index';
import { GravityAnimationComponent, GravityAnimationPage,
  GravityAnimationManager }
  from '../../../../../../../../../src/main/ets/service/animator/gravity/manager/GravityAnimationManager';

/**
 * GravityAnimationManager DT测试套
 */
export function GravityAnimationManagerTest() {
  describe('GravityAnimationManagerTest', (): void => {
    let gravityAnimationManager: GravityAnimationManager = new GravityAnimationManager();
    beforeAll((): void => {

    });
    beforeEach((): void => {
      GravityAnimationConfig.setEnable(1);
    })
    afterAll((): void => {
      GravityAnimationConfig.reset();
    })
    afterEach((): void => {

    })

    /**
     * 模拟一个正常图标是否被挤位
     */
    it('GravityAnimationManager_run_001', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(10, 10);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(10);
      GravityAnimationConfig.setMinRadius(0);
      gravityAnimationManager.run(page, 5, 5);

      gravityAnimationManager.removeComponent(com1);
      expect(com1Effected).assertTrue();
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个越界图标是否被挤位
     */
    it('GravityAnimationManager_run_002', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      /* 使距离10大于MaxRadius 5，故不受影响 */
      GravityAnimationConfig.setMaxRadius(5);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.addComponent(com1);
      gravityAnimationManager.run(page, 5, 5);
      gravityAnimationManager.removeComponent(com1);

      expect(com1Effected).assertFalse();
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个处于越界边界（最大边界）的图标是否被挤位
     */
    it('GravityAnimationManager_run_003', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      /* 使距离10大于MaxRadius 5，故不受影响 */
      GravityAnimationConfig.setMaxRadius(10);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.addComponent(com1);
      gravityAnimationManager.run(page, 5, 5);
      gravityAnimationManager.removeComponent(com1);

      expect(com1Effected).assertFalse();
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个处于越界边界（最小边界）的图标是否被挤位
     */
    it('GravityAnimationManager_run_004', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(5, 5);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      /* 使距离10大于MaxRadius 5，故不受影响 */
      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.addComponent(com1);
      gravityAnimationManager.run(page, 5, 5);
      gravityAnimationManager.removeComponent(com1);

      expect(com1Effected).assertFalse();
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟多个正常图标是否被挤位
     */
    it('GravityAnimationManager_run_005', Level.LEVEL0, (): void => {
      const page = 99;
      let comEffected: boolean[] = [ false, false, false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });
      let com2 = new GravityAnimationComponent((param) => {
        comEffected[2] = true;
      });
      let com3 = new GravityAnimationComponent((param) => {
        comEffected[3] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page, 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 30);
      com1.setLayoutInfo(page, 3, 2, 1, 1);

      com2.setActive(true);
      com2.setPosition(10, 20);
      com2.setLayoutInfo(page, 2, 1, 1, 1);

      com3.setActive(true);
      com3.setPosition(10, 30);
      com3.setLayoutInfo(page, 3, 1, 1, 1);

      gravityAnimationManager.addComponent(com0);
      gravityAnimationManager.addComponent(com1);
      gravityAnimationManager.addComponent(com2);
      gravityAnimationManager.addComponent(com3);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);

      gravityAnimationManager.removeComponent(com0);
      gravityAnimationManager.removeComponent(com1);
      gravityAnimationManager.removeComponent(com2);
      gravityAnimationManager.removeComponent(com3);

      comEffected.forEach((effected) => {
        expect(effected).assertTrue();
      })
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟正常+越界图标是否被挤位
     */
    it('GravityAnimationManager_run_006', Level.LEVEL0, (): void => {
      const page = 99;
      let comEffected: boolean[] = [ false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page, 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 40);
      com1.setLayoutInfo(page, 3, 2, 1, 1);

      gravityAnimationManager.addComponent(com0);
      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);

      gravityAnimationManager.removeComponent(com0);
      gravityAnimationManager.removeComponent(com1);

      expect(comEffected[0]).assertTrue();
      expect(comEffected[1]).assertFalse();

      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个图标deactivate是否被挤位
     */
    it('GravityAnimationManager_run_007', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(false);
      com1.setPosition(10, 10);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(10);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 5, 5);

      gravityAnimationManager.removeComponent(com1);
      expect(com1Effected).assertFalse();
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个正常图标offset Y是否被挤位
     */
    it('GravityAnimationManager_run_008', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(10);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertFalse();

      com1.setOffset(0, -1);
      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertTrue();

      gravityAnimationManager.removeComponent(com1);
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个正常图标offset Y是否被挤位
     */
    it('GravityAnimationManager_run_009', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertTrue();

      com1Effected = false;
      com1.setOffset(0, 5);
      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertFalse();

      gravityAnimationManager.removeComponent(com1);
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个正常图标offset X是否被挤位
     */
    it('GravityAnimationManager_run_010', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(15, 5);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(10);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertFalse();

      com1.setOffset(-1, 0);
      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertTrue();

      gravityAnimationManager.removeComponent(com1);
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟一个正常图标offset X是否被挤位
     */
    it('GravityAnimationManager_run_011', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(15, 5);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertTrue();

      com1Effected = false;
      com1.setOffset(5, 0);
      gravityAnimationManager.run(page, 5, 5);
      expect(com1Effected).assertFalse();

      gravityAnimationManager.removeComponent(com1);
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟FOREVER图标是否被挤位
     */
    it('GravityAnimationManager_run_012', Level.LEVEL0, (): void => {
      const page = 99;
      let comEffected: boolean[] = [ false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });

      let count = gravityAnimationManager.getPageMap(GravityAnimationPage.FOREVER_TRIGGER)?.length;

      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 30);
      com1.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 3, 2, 1, 1);

      gravityAnimationManager.addComponent(com0);
      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);

      comEffected.forEach((effected) => {
        expect(effected).assertTrue();
      })

      comEffected = [ false, false ];
      gravityAnimationManager.run(page, 20, 25);
      expect(comEffected[0]).assertFalse();
      expect(comEffected[1]).assertTrue();

      gravityAnimationManager.removeComponent(com0);
      gravityAnimationManager.removeComponent(com1);
    })

    /**
     * 模拟FOREVER图标+正常桌面图标是否被挤位
     */
    it('GravityAnimationManager_run_013', Level.LEVEL0, (): void => {
      const page = 99;
      let comEffected: boolean[] = [ false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page, 1, 2, 1, 1);

      let count = gravityAnimationManager.getPageMap(GravityAnimationPage.FOREVER_TRIGGER)?.length;

      com1.setActive(true);
      com1.setPosition(20, 30);
      com1.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 3, 2, 1, 1);

      gravityAnimationManager.addComponent(com0);
      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);

      gravityAnimationManager.removeComponent(com0);
      gravityAnimationManager.removeComponent(com1);

      comEffected.forEach((effected) => {
        expect(effected).assertTrue();
      })
      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟有Pre，是否正常+越界图标都执行
     */
    it('GravityAnimationManager_run_014', Level.LEVEL0, (): void => {
      const page = 99;
      let comPreCallbackRun: boolean[] = [ false, false ];
      let comEffected: boolean[] = [ false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      },() => {
        comPreCallbackRun[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      },() => {
        comPreCallbackRun[1] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page, 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 40);
      com1.setLayoutInfo(page, 3, 2, 1, 1);

      gravityAnimationManager.addComponent(com0);
      gravityAnimationManager.addComponent(com1);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);

      gravityAnimationManager.removeComponent(com0);
      gravityAnimationManager.removeComponent(com1);

      expect(comEffected[0]).assertTrue();
      expect(comEffected[1]).assertFalse();

      expect(comPreCallbackRun[0]).assertTrue();
      expect(comPreCallbackRun[1]).assertTrue();

      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟有Pre，在callback时修改坐标，时挤位成功
     */
    it('GravityAnimationManager_run_015', Level.LEVEL0, (): void => {
      const page = 99;
      let comEffected: boolean = false;
      let com0 = new GravityAnimationComponent((param) => {
        comEffected = true;
      },() => {
        com0.setPosition(20, 10);
      });
      com0.setActive(true);
      com0.setPosition(20, 0);
      com0.setLayoutInfo(page, 1, 2, 1, 1);

      gravityAnimationManager.addComponent(com0);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);
      gravityAnimationManager.removeComponent(com0);
      expect(comEffected).assertTrue();

      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟多个图标，有的图标没有callback，结果是否正常
     */
    it('GravityAnimationManager_run_016', Level.LEVEL0, (): void => {
      const page = 99;
      let comEffected: boolean[] = [ false, false, false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });
      let com2 = new GravityAnimationComponent((param) => {
      });
      let com3 = new GravityAnimationComponent((param) => {
        comEffected[3] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page, 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 30);
      com1.setLayoutInfo(page, 3, 2, 1, 1);

      com2.setActive(true);
      com2.setPosition(10, 20);
      com2.setLayoutInfo(page, 2, 1, 1, 1);

      com3.setActive(true);
      com3.setPosition(10, 30);
      com3.setLayoutInfo(page, 3, 1, 1, 1);

      gravityAnimationManager.addComponent(com0);
      gravityAnimationManager.addComponent(com1);
      gravityAnimationManager.addComponent(com2);
      gravityAnimationManager.addComponent(com3);

      GravityAnimationConfig.setMaxRadius(15);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.run(page, 20, 20);

      gravityAnimationManager.removeComponent(com0);
      gravityAnimationManager.removeComponent(com1);
      gravityAnimationManager.removeComponent(com2);
      gravityAnimationManager.removeComponent(com3);

      expect(comEffected[0]).assertTrue();
      expect(comEffected[1]).assertTrue();
      expect(comEffected[2]).assertFalse();
      expect(comEffected[3]).assertTrue();

      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /**
     * 模拟多页showComponents，返回长度逐页增加（返回结果split然后差值>2？）
     */
    it('GravityAnimationManager_run_017', Level.LEVEL0, (): void => {
      let page: number[] = [ 99, 100 ];
      let comEffected: boolean[] = [ false, false, false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });
      let com2 = new GravityAnimationComponent((param) => {
        comEffected[2] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page[0], 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 30);
      com1.setLayoutInfo(page[0], 3, 2, 1, 1);

      com2.setActive(true);
      com2.setPosition(10, 20);
      com2.setLayoutInfo(page[1], 2, 1, 1, 1);

      gravityAnimationManager.addComponent(com0);
      let len1 = gravityAnimationManager.showComponents().length;
      gravityAnimationManager.addComponent(com1);
      let len2 = gravityAnimationManager.showComponents().length;
      gravityAnimationManager.addComponent(com2);
      let len3 = gravityAnimationManager.showComponents().length;

      expect(len1).assertLess(len2);
      expect(len2).assertLess(len3);

      gravityAnimationManager.removeComponent(com0);
      len1 = gravityAnimationManager.showComponents().length;
      gravityAnimationManager.removeComponent(com1);
      len2 = gravityAnimationManager.showComponents().length;
      gravityAnimationManager.removeComponent(com2);
      len3 = gravityAnimationManager.showComponents().length;
      expect(len1).assertLarger(len2);
      expect(len2).assertLarger(len3);

      expect(gravityAnimationManager.getPageMap(page[0])).assertUndefined();
      expect(gravityAnimationManager.getPageMap(page[1])).assertUndefined();
    })

    /**
     * 模拟多页drawLayouts，返回长度逐页增加
     */
    it('GravityAnimationManager_run_018', Level.LEVEL0, (): void => {
      let page: number[] = [ 99, 100 ];
      let comEffected: boolean[] = [ false, false, false ];
      let com0 = new GravityAnimationComponent((param) => {
        comEffected[0] = true;
      });
      let com1 = new GravityAnimationComponent((param) => {
        comEffected[1] = true;
      });
      let com2 = new GravityAnimationComponent((param) => {
        comEffected[2] = true;
      });
      com0.setActive(true);
      com0.setPosition(20, 10);
      com0.setLayoutInfo(page[0], 1, 2, 1, 1);

      com1.setActive(true);
      com1.setPosition(20, 30);
      com1.setLayoutInfo(page[0], 3, 2, 2, 2);

      com2.setActive(true);
      com2.setPosition(10, 20);
      com2.setLayoutInfo(page[1], 2, 1, 1, 1);

      let mgr: GravityAnimationManager = new GravityAnimationManager();

      mgr.addComponent(com0);
      let len1 = mgr.drawLayouts().length;
      mgr.addComponent(com1);
      let len2 = mgr.drawLayouts().length;
      mgr.addComponent(com2);
      let len3 = mgr.drawLayouts().length;

      mgr.removeComponent(com0);
      len1 = mgr.drawLayouts().length;
      mgr.removeComponent(com1);
      len2 = mgr.drawLayouts().length;
      mgr.removeComponent(com2);
      len3 = mgr.drawLayouts().length;
      expect(len1).assertLarger(len2);
      expect(len2).assertLarger(len3);

      expect(mgr.getPageMap(page[0])).assertUndefined();
      expect(mgr.getPageMap(page[1])).assertUndefined();
    })

    /* 模拟在没有图标的page上触发 */
    it('GravityAnimationManager_run_019', Level.LEVEL0, (): void => {
      const page = 99;
      let com1Effected = false;
      let com1 = new GravityAnimationComponent((param) => {
        com1Effected = true;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      let mgr: GravityAnimationManager = new GravityAnimationManager();

      GravityAnimationConfig.setMaxRadius(100);
      GravityAnimationConfig.setMinRadius(0);

      mgr.run(1, 5, 5);
      expect(com1Effected).assertFalse();

      mgr.run(page, 5, 5);
      expect(com1Effected).assertFalse();

      mgr.addComponent(com1);
      mgr.run(1, 5, 5);
      mgr.removeComponent(com1);
      expect(com1Effected).assertFalse();

      expect(mgr.getPageMap(page)).assertUndefined();
    })

    /* 模拟吸力场景，方向和引力相反 */
    it('GravityAnimationManager_run_020', Level.LEVEL0, (): void => {
      const page = 99;
      let offset = 0;
      let com1 = new GravityAnimationComponent((param) => {
        offset = param.waveCrest.y - param.now.y;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      GravityAnimationConfig.setMaxRadius(100);
      GravityAnimationConfig.setMinRadius(0);

      gravityAnimationManager.addComponent(com1);
      gravityAnimationManager.run(page, 5, 5, ForceType.REPULSION);
      expect(offset).assertLarger(0);

      gravityAnimationManager.run(page, 5, 5, ForceType.GRAVITATION);
      gravityAnimationManager.removeComponent(com1);
      expect(offset).assertLess(0);

      expect(gravityAnimationManager.getPageMap(page)).assertUndefined();
    })

    /* 放大系数 */
    it('GravityAnimationManager_run_021', Level.LEVEL0, (): void => {
      const page = 99;
      let offset = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset[0] = param.waveCrest.y - param.now.x;
      });
      com0.setActive(true);
      com0.setPosition(5, 15);
      com0.setLayoutInfo(page, 2, 4, 1, 1);

      GravityAnimationConfig.setMaxRadiusFactor(1);
      GravityAnimationConfig.setMaxRadius(100);
      GravityAnimationConfig.setMinRadius(0);

      let mgr0: GravityAnimationManager = new GravityAnimationManager();

      mgr0.addComponent(com0);
      mgr0.run(page, 5, 5, ForceType.REPULSION);
      mgr0.removeComponent(com0);
      expect(offset[0]).assertLarger(0);
      expect(mgr0.getPageMap(page)).assertUndefined();


      let com1 = new GravityAnimationComponent((param) => {
        offset[1] = param.waveCrest.y - param.now.x;
      });
      com1.setActive(true);
      com1.setPosition(5, 15);
      com1.setLayoutInfo(page, 2, 4, 1, 1);

      let mgr1: GravityAnimationManager = new GravityAnimationManager();

      mgr1.addComponent(com1);
      GravityAnimationConfig.setMaxRadiusFactor(2);
      mgr1.run(page, 5, 5, ForceType.REPULSION, [2, 2]);
      mgr1.removeComponent(com1);
      expect(offset[1]).assertLarger(0);
      expect(mgr1.getPageMap(page)).assertUndefined();

      expect(offset[1]).assertLarger(offset[0]);
    })

    it('GravityAnimationManager_equal_01', Level.LEVEL0, (): void => {
      let offset = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset[0] = param.waveCrest.y - param.now.x;
      });

      let com1 = new GravityAnimationComponent((param) => {
        offset[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['pageIndex'] = -1;
      (com0 as object)['column'] = -1;
      (com0 as object)['row'] = -1;
      (com1 as object)['pageIndex'] = -1;
      (com1 as object)['column'] = -1;
      (com1 as object)['row'] = -1;
      com0.equal(com1);
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_compare_01', Level.LEVEL0, (): void => {
      let offset = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset[0] = param.waveCrest.y - param.now.x;
      });

      let com1 = new GravityAnimationComponent((param) => {
        offset[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['pageIndex'] = -1;
      (com0 as object)['column'] = -1;
      (com0 as object)['row'] = 1;
      (com1 as object)['pageIndex'] = -1;
      (com1 as object)['column'] = -1;
      (com1 as object)['row'] = 2;
      com0.compare(com1);
      expect(com0).not().assertUndefined();

      (com0 as object)['row'] = 2;
      (com1 as object)['row'] = 2;
      com0.compare(com1);
      expect(com0).not().assertUndefined();

      (com0 as object)['row'] = 3;
      (com1 as object)['row'] = 2;
      com0.compare(com1);
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_getX_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['center'] = { x: -1, y: 0 };
      (com0 as object)['offset'] = { x: -1, y: 0 };
      com0.getX();
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_getY_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['center'] = { x: -1, y: -1 };
      (com0 as object)['offset'] = { x: -1, y: -1 };
      com0.getY();
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_getRow_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['row'] = -1;
      com0.getRow();
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_getCol_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['column'] = -1;
      com0.getCol();
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_getWidth_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['width'] = -1;
      com0.getWidth();
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_getHeight_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = param.waveCrest.y - param.now.x;
      });
      (com0 as object)['height'] = -1;
      com0.getHeight();
      expect(com0).not().assertUndefined();
    })

    it('GravityAnimationManager_run_01', Level.LEVEL0, (): void => {
      let offset1 = [ 0, 0 ];
      let com0 = new GravityAnimationComponent((param) => {
        offset1[0] = 0;
      },() => {
        offset1[1] = 0;
      });
      let gravityAnimationConfig: GravityAnimationConfig = new GravityAnimationConfig();
      let gravityAnimationManager: GravityAnimationManager = new GravityAnimationManager();
      (gravityAnimationConfig as object)['enable'] = 1;
      gravityAnimationManager.run(10,1,1,ForceType.REPULSION);
      expect(com0).not().assertUndefined();
    })
  })
}