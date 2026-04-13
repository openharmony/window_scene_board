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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { AnimateParams, LiveVmInjector } from '../../../../../../../newIndex';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleLightWaveVm } from '../../../../../../main/ets/live/vm/LiveCapsuleLightWaveVm';
import { curves } from '@kit.ArkUI';

const CAPSULE_LIGHT_WAVE_CURVE = curves.cubicBezierCurve(0.08, 0.21, 0.30, 1.00);
const LIGHT_FINISH_DELAY = 730;

export default function LiveCapsuleLightWaveVmTest() {
  describe('setAnimStartState_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    setAnimStartStateTest1();
    setAnimStartStateTest2();
    setAnimStartStateTest3();
  });

  describe('doWaveAnim_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    doWaveAnimTest1();
    doWaveAnimTest2();
    doWaveAnimTest3();
    doWaveAnimTest4();
    doWaveAnimTest5();
    doWaveAnimTest6();
    doWaveAnimTest7();
    doWaveAnimTest8();
    doWaveAnimTest9();
    doWaveAnimTest10();
    doWaveAnimTest11();
    doWaveAnimTest12();
    doWaveAnimTest13();
    doWaveAnimTest14();
    doWaveAnimTest15();
    doWaveAnimTest16();
    doWaveAnimTest17();
    doWaveAnimTest18();
    doWaveAnimTest19();
    doWaveAnimTest20();
    doWaveAnimTest21();
    doWaveAnimTest22();
    doWaveAnimTest23();
    doWaveAnimTest24();
    doWaveAnimTest25();
    doWaveAnimTest26();
    doWaveAnimTest27();
    doWaveAnimTest28();
    doWaveAnimTest29();
    doWaveAnimTest30();
  })

  describe('doProgressWaveAnim_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    doProgressWaveAnimTest1();
    doProgressWaveAnimTest2();
    doProgressWaveAnimTest3();
    doProgressWaveAnimTest4();
    doProgressWaveAnimTest5();
    doProgressWaveAnimTest6();
    doProgressWaveAnimTest7();
    doProgressWaveAnimTest8();
    doProgressWaveAnimTest9();
    doProgressWaveAnimTest10();
    doProgressWaveAnimTest11();
    doProgressWaveAnimTest12();
    doProgressWaveAnimTest13();
    doProgressWaveAnimTest14();
    doProgressWaveAnimTest15();
    doProgressWaveAnimTest16();
    doProgressWaveAnimTest17();
    doProgressWaveAnimTest18();
    doProgressWaveAnimTest19();
    doProgressWaveAnimTest20();
    doProgressWaveAnimTest21();
    doProgressWaveAnimTest22();
    doProgressWaveAnimTest23();
    doProgressWaveAnimTest24();
    doProgressWaveAnimTest25();
    doProgressWaveAnimTest26();
    doProgressWaveAnimTest27();
    doProgressWaveAnimTest28();
    doProgressWaveAnimTest29();
    doProgressWaveAnimTest30();
    doProgressWaveAnimTest31();
    doProgressWaveAnimTest32();
    doProgressWaveAnimTest33();
    doProgressWaveAnimTest34();
    doProgressWaveAnimTest35();
    doProgressWaveAnimTest36();
    doProgressWaveAnimTest37();
    doProgressWaveAnimTest38();
    doProgressWaveAnimTest39();
    doProgressWaveAnimTest40();
    doProgressWaveAnimTest41();
    doProgressWaveAnimTest42();
    doProgressWaveAnimTest43();
    doProgressWaveAnimTest44();
    doProgressWaveAnimTest45();
    doProgressWaveAnimTest46();
    doProgressWaveAnimTest47();
    doProgressWaveAnimTest48();
    doProgressWaveAnimTest49();
    doProgressWaveAnimTest50();
    doProgressWaveAnimTest51();
    doProgressWaveAnimTest52();
    doProgressWaveAnimTest53();
    doProgressWaveAnimTest54();
    doProgressWaveAnimTest55();
    doProgressWaveAnimTest56();
    doProgressWaveAnimTest57();
    doProgressWaveAnimTest58();
    doProgressWaveAnimTest59();
    doProgressWaveAnimTest60();
    doProgressWaveAnimTest61();
    doProgressWaveAnimTest62();
    doProgressWaveAnimTest63();
    doProgressWaveAnimTest64();
    doProgressWaveAnimTest65();
    doProgressWaveAnimTest66();
    doProgressWaveAnimTest67();
    doProgressWaveAnimTest68();
    doProgressWaveAnimTest69();
    doProgressWaveAnimTest70();
    doProgressWaveAnimTest71();
    doProgressWaveAnimTest72();
  });
}

function setAnimStartStateTest1() {
  it('should_set_correct_values_when_offset_is_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    lightWaveVm.setAnimStartState(0);

    expect(lightWaveVm.lightWidth).assertEqual(0.4);
    expect(lightWaveVm.lightOffset).assertEqual(0);
    expect(lightWaveVm.lightRadius).assertEqual(2.5 * LiveStyle.CAPSULE_HEIGHT);
    expect(lightWaveVm.lightBlur).assertEqual(LiveStyle.CAPSULE_HEIGHT);
    expect(lightWaveVm.lightOpacity).assertEqual(0);
  });
}

function setAnimStartStateTest2() {
  it('should_set_correct_values_when_offset_is_positive', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    lightWaveVm.setAnimStartState(100);

    expect(lightWaveVm.lightWidth).assertEqual(0.4);
    expect(lightWaveVm.lightOffset).assertEqual(100);
    expect(lightWaveVm.lightRadius).assertEqual(2.5 * LiveStyle.CAPSULE_HEIGHT);
    expect(lightWaveVm.lightBlur).assertEqual(LiveStyle.CAPSULE_HEIGHT);
    expect(lightWaveVm.lightOpacity).assertEqual(0);
  });
}

function setAnimStartStateTest3() {
  it('should_set_correct_values_when_offset_is_negative', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    lightWaveVm.setAnimStartState(-100);

    expect(lightWaveVm.lightWidth).assertEqual(0.4);
    expect(lightWaveVm.lightOffset).assertEqual(-100);
    expect(lightWaveVm.lightRadius).assertEqual(2.5 * LiveStyle.CAPSULE_HEIGHT);
    expect(lightWaveVm.lightBlur).assertEqual(LiveStyle.CAPSULE_HEIGHT);
    expect(lightWaveVm.lightOpacity).assertEqual(0);
  });
}

function doWaveAnimTest1() {
  it('should_return_correct_animate_params_when_delay_is_0_and_lightOffset_is_80', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(0, 80);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest2() {
  it('should_return_correct_animate_params_when_delay_is_500_and_lightOffset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(500, 100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(500);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130 + 500);
  });
}

function doWaveAnimTest3() {
  it('should_return_correct_animate_params_when_delay_is_negative_and_lightOffset_is_negative', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-100, -50);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130 + 0);
  });
}

function doWaveAnimTest4() {
  it('should_return_correct_animate_params_when_delay_is_positive_and_lightOffset_is_positive', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(100, 50);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(100);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130 + 100);
  });
}

function doWaveAnimTest5() {
  it('should_return_correct_animate_params_when_delay_is_negative_and_lightOffset_is_positive', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-100, 50);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130 + 0);
  });
}

function doWaveAnimTest6() {
  it('should_return_correct_animate_params_when_delay_is_100_and_lightOffset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(100, 100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest7() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_lightOffset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-100, -100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest8() {
  it('should_return_correct_animate_params_when_delay_is_100_and_lightOffset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(100, -100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest9() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_lightOffset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-100, 100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest10() {
  it('should_return_correct_animate_params_when_delay_is_200_and_lightOffset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(200, 200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest11() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_lightOffset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-200, -200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest12() {
  it('should_return_correct_animate_params_when_delay_is_200_and_lightOffset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(200, -200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest13() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_lightOffset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-200, 200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest14() {
  it('should_return_correct_animate_params_when_delay_is_200_and_lightOffset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(200, 100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest15() {
  it('should_return_correct_animate_params_when_delay_is_100_and_lightOffset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(100, 200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest16() {
  it('should_return_correct_animate_params_when_delay_is_200_and_lightOffset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(200, -100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest17() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_lightOffset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-100, 200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest18() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_lightOffset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-200, 100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest19() {
  it('should_return_correct_animate_params_when_delay_is_100_and_lightOffset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(100, -200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest20() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_lightOffset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-200, -100);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest21() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_lightOffset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-100, -200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest22() {
  it('should_return_correct_animate_params_when_delay_is_0_and_lightOffset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(0, -200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest23() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_lightOffset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-200, 0);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest24() {
  it('should_return_correct_animate_params_when_delay_is_0_and_lightOffset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(0, 200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest25() {
  it('should_return_correct_animate_params_when_delay_is_200_and_lightOffset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(200, 0);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest26() {
  it('should_return_correct_animate_params_when_delay_is_300_and_lightOffset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(300, 0);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest27() {
  it('should_return_correct_animate_params_when_delay_is_0_and_lightOffset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(0, 300);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest28() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_lightOffset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(-300, 0);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest29() {
  it('should_return_correct_animate_params_when_delay_is_0_and_lightOffset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(0, -300);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doWaveAnimTest30() {
  it('should_return_correct_animate_params_when_delay_is_300_and_lightOffset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doWaveAnim(300, 200);

    expect(result.length).assertEqual(2);

    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].duration).assertEqual(130);
    expect(result[0].delay).assertEqual(0);

    expect(result[1].curve).assertEqual(CAPSULE_LIGHT_WAVE_CURVE);
    expect(result[1].duration).assertEqual(600);
    expect(result[1].delay).assertEqual(130);
  });
}

function doProgressWaveAnimTest1() {
  it('should_return_correct_animate_params_when_delay_and_offset_are_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(0, 0);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 0);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest2() {
  it('should_return_correct_animate_params_when_delay_is_non_zero_and_offset_is_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, 0);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest3() {
  it('should_return_correct_animate_params_when_delay_is_zero_and_offset_is_non_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(0, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 0);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest4() {
  it('should_return_correct_animate_params_when_delay_and_offset_are_non_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest5() {
  it('should_return_correct_animate_params_when_delay_is_50_and_offset_is_50', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(50, 50);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest6() {
  it('should_return_correct_animate_params_when_delay_is_50_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(50, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest7() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_50', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, 50);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest8() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, 200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest9() {
  it('should_return_correct_animate_params_when_delay_is_0_and_offset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(0, 200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest10() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, 0);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest11() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest12() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 0);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest13() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_50', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 50);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest14() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest15() {
  it('should_return_correct_animate_params_when_delay_is_50_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(50, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest16() {
  it('should_return_correct_animate_params_when_delay_is_100_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest17() {
  it('should_return_correct_animate_params_when_delay_is_-50_and_offset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-50, 0);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest18() {
  it('should_return_correct_animate_params_when_delay_is_0_and_offset_is_-50', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(0, -50);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest19() {
  it('should_return_correct_animate_params_when_delay_is_-50_and_offset_is_-50', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-50, -50);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest20() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_offset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-100, -100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest21() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_offset_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-100, 0);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest22() {
  it('should_return_correct_animate_params_when_delay_is_0_and_offset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(0, -100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest23() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_offset_is_-50', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-100, -50);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest24() {
  it('should_return_correct_animate_params_when_delay_is_-50_and_offset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-50, -100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest25() {
  it('should_return_correct_animate_params_when_delay_is_-100_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-100, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest26() {
  it('should_return_correct_animate_params_when_delay_is_100_and_offset_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, -100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest27() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest28() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest29() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest30() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest31() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest32() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest33() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest34() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-200, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest35() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest36() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest37() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest38() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest39() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-200, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest40() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest41() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_00', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest42() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest43() {
  it('should_return_correct_animate_params_when_delay_is_-250_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest44() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest45() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest46() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest47() {
  it('should_return_correct_animate_params_when_delay_is_-250_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest48() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest49() {
  it('should_return_correct_animate_params_when_delay_is_100_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest50() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest51() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest52() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest53() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest54() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest55() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest56() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest57() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-200, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest58() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest59() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest60() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest61() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest62() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-200, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest63() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest64() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_00', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest65() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest66() {
  it('should_return_correct_animate_params_when_delay_is_-250_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest67() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest68() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest69() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest70() {
  it('should_return_correct_animate_params_when_delay_is_-250_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest71() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest72() {
  it('should_return_correct_animate_params_when_delay_is_100_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest73() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest74() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest75() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest76() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest77() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest78() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest79() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest80() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-200, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest81() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest82() {
  it('should_return_correct_animate_params_when_delay_is_200_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(200, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest83() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest84() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -200);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest85() {
  it('should_return_correct_animate_params_when_delay_is_-200_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-200, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest86() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest87() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_00', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest88() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest89() {
  it('should_return_correct_animate_params_when_delay_is_-250_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest90() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest91() {
  it('should_return_correct_animate_params_when_delay_is_250_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest92() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_-250', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, -250);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest93() {
  it('should_return_correct_animate_params_when_delay_is_-250_and_offset_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-250, -300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest94() {
  it('should_return_correct_animate_params_when_delay_is_300_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(300, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest95() {
  it('should_return_correct_animate_params_when_delay_is_100_and_offset_is_300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(100, 300);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}

function doProgressWaveAnimTest96() {
  it('should_return_correct_animate_params_when_delay_is_-300_and_offset_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let lightWaveVm: LiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm(liveVmInjector, live);
    let result: AnimateParams[] = lightWaveVm.doProgressWaveAnim(-300, 100);
    expect(result.length).assertEqual(3);
    expect(result[0].curve).assertEqual(curves.Curve.Linear);
    expect(result[0].delay).assertEqual(0);
    expect(result[0].duration).assertEqual(130);

    expect(result[1].curve).assertEqual(curves.Curve.Linear);
    expect(result[1].delay).assertEqual(130 + 100);
    expect(result[1].duration).assertEqual(600);

    expect(result[2].curve).assertEqual(curves.Curve.Linear);
    expect(result[2].delay).assertEqual(LIGHT_FINISH_DELAY + 100);
    expect(result[2].duration).assertEqual(1);
  });
}