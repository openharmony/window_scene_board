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
import { BallParams, MetaballAnimationScene } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveMetaBallVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVm';
import { StatusBarCapsulePosition } from '../../../../../../main/ets/statusbar/model/StatusBarCapsulePosition';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LiveMetaBallBaseVm } from '../../../../../../main/ets/live/vm/LiveMetaBallBaseVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveThreeMetaBallVm } from '../../../../../../main/ets/live/vm/LiveThreeMetaBallVm';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';

export default function LiveThreeMetaBallVmTest() {
    describe('getWidth_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_width', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = 2;
            liveThreeMetaballVm.animStatusBarHeight =
                LiveStyle.CAPSULE_HEIGHT * widthFactor / 2 + liveThreeMetaballVm.cutoutVm.holes[0].centerY;
            let result = liveThreeMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(100 * 2);
        });

        it('should_return_correct_width1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = 3;
            liveThreeMetaballVm.animStatusBarHeight =
                LiveStyle.CAPSULE_HEIGHT * widthFactor / 2 + liveThreeMetaballVm.cutoutVm.holes[0].centerY;
            let result = liveThreeMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(100 * 3);
        });

        it('should_return_correct_width2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = -2;
            liveThreeMetaballVm.animStatusBarHeight =
                LiveStyle.CAPSULE_HEIGHT * widthFactor / 2 + liveThreeMetaballVm.cutoutVm.holes[0].centerY;
            let result = liveThreeMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(-100 * 2);
        });

        it('should_return_width_when_capsulePosition_is_null', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let widthFactor: number = 2;
            liveThreeMetaballVm.animStatusBarHeight =
                LiveStyle.CAPSULE_HEIGHT * widthFactor / 2 + liveThreeMetaballVm.cutoutVm.holes[0].centerY;
            try {
                liveThreeMetaballVm.getWidth(capsulePosition);
            } catch (e) {
                expect(e.message).assertEqual("capsulePosition is null");
            }
        });

        it('should_return_width_when_capsulePosition_is_null1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let widthFactor: number = 3;
            liveThreeMetaballVm.animStatusBarHeight =
                LiveStyle.CAPSULE_HEIGHT * widthFactor / 2 + liveThreeMetaballVm.cutoutVm.holes[0].centerY;
            try {
                liveThreeMetaballVm.getWidth(capsulePosition);
            } catch (e) {
                expect(e.message).assertEqual("capsulePosition is null");
            }
        });

        it('should_return_width_when_capsulePosition_is_null2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let widthFactor: number = 4;
            liveThreeMetaballVm.animStatusBarHeight =
                LiveStyle.CAPSULE_HEIGHT * widthFactor / 2 + liveThreeMetaballVm.cutoutVm.holes[0].centerY;
            try {
                liveThreeMetaballVm.getWidth(capsulePosition);
            } catch (e) {
                expect(e.message).assertEqual("capsulePosition is null");
            }
        });
    });

    describe('getHeight_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_height', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            const heightFactor = 1.5;
            expect(result).assertEqual(100 * heightFactor);
        });

        it('should_return_correct_height1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            const heightFactor = 2;
            expect(result).assertEqual(100 * heightFactor);
        });

        it('should_return_correct_height2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            const heightFactor = 2.5;
            expect(result).assertEqual(100 * heightFactor);
        });

        it('should_return_zero_when_capsulePosition_is_null', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_zero_when_capsulePosition_is_null1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            capsulePosition.width = 10;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_zero_when_capsulePosition_is_null2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            capsulePosition.width = 0;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_correct_height_when_heightFactor_is_zero', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            const heightFactor = 0;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(100 * heightFactor);
        });

        it('should_return_correct_height_when_heightFactor_is_zero1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 200;
            const heightFactor = 0;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(200 * heightFactor);
        });

        it('should_return_correct_height_when_heightFactor_is_zero2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 300;
            const heightFactor = 0;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(300 * heightFactor);
        });

        it('should_return_correct_height_when_heightFactor_is_negative', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -100;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(-150);
        });

        it('should_return_correct_height_when_heightFactor_is_negative1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -200;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(-300);
        });

        it('should_return_correct_height_when_heightFactor_is_negative2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -300;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(-450);
        });

        it('should_return_correct_height_when_heightFactor_is_positive', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(150);
        });

        it('should_return_correct_height_when_heightFactor_is_positive1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 200;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(300);
        });

        it('should_return_correct_height_when_heightFactor_is_positive2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 300;
            let result = liveThreeMetaballVm.getHeight(capsulePosition);
            expect(result).assertEqual(450);
        });

    });

    describe('getPosition_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_position_when_capsulePosition_is_valid', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            const heightFactor = 1.5;
            expect(result.top).assertEqual(-capsulePosition.height * (heightFactor - 1) / 2);
        });

        it('should_return_correct_position_when_capsulePosition_is_valid1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 200;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            const heightFactor = 1.5;
            expect(result.top).assertEqual(-capsulePosition.height * (heightFactor - 1) / 2);
        });

        it('should_return_correct_position_when_capsulePosition_is_valid2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 300;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            const heightFactor = 1.5;
            expect(result.top).assertEqual(-capsulePosition.height * (heightFactor - 1) / 2);
        });

        it('should_return_default_position_when_capsulePosition_is_null', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_default_position_when_capsulePosition_is_null1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_default_position_when_capsulePosition_is_null2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_default_position_when_capsulePosition_height_is_zero', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_default_position_when_capsulePosition_height_is_zero1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            capsulePosition.width = 10;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_default_position_when_capsulePosition_height_is_zero2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            capsulePosition.width = 20;
            let result: Edges = liveThreeMetaballVm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });
    });

    describe('getBallParam_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_ball_params_when_capsule_position_is_valid', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 25, radius: 6 },
                { centerX: 20, centerY: 30, radius: 6 },
                { centerX: 25, centerY: 35, radius: 6 }
            ];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_correct_ball_params_when_capsule_position_is_valid1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 20, radius: 6 },
                { centerX: 20, centerY: 30, radius: 6 },
                { centerX: 25, centerY: 40, radius: 6 }
            ];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(20);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(40);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_correct_ball_params_when_capsule_position_is_valid2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 5, radius: 6 },
                { centerX: 20, centerY: 10, radius: 6 },
                { centerX: 25, centerY: 15, radius: 6 }
            ];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(5);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(10);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_correct_ball_params_when_capsule_position_is_valid3', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 25, radius: 6 },
                { centerX: 20, centerY: 30, radius: 6 },
                { centerX: 25, centerY: 35, radius: 6 }
            ];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_correct_ball_params_when_capsule_position_is_valid4', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 20, radius: 6 },
                { centerX: 20, centerY: 30, radius: 6 },
                { centerX: 25, centerY: 40, radius: 6 }
            ];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(20);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(40);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_correct_ball_params_when_capsule_position_is_valid5', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 5, radius: 6 },
                { centerX: 20, centerY: 10, radius: 6 },
                { centerX: 25, centerY: 15, radius: 6 }
            ];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(5);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(10);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_empty_array_when_capsule_position_is_null', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(new StatusBarCapsulePosition());
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_is_null1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(new StatusBarCapsulePosition());
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_is_null2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(new StatusBarCapsulePosition());
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_has_no_holes', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_has_no_holes1', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 20;
            capsulePosition.top = 20;
            capsulePosition.holes = [];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_has_no_holes2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 20;
            capsulePosition.top = 40;
            capsulePosition.holes = [];
            let result: BallParams[] = liveThreeMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(0);
        });
    });

    describe('toggleState_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_call_fusionBall_with_correct_parameters', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let mockGetAnimateParam: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            let mockFusionBall: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);

            let animateParam: AnimateParam = new AnimateParam();
            when(mockGetAnimateParam)([]).afterReturn(animateParam);

            when(mockFusionBall)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean],
                ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterReturn(Promise.resolve());

            await liveThreeMetaballVm.toggleState();

            expect(mockFusionBall).assertCalledWith([true, true, true], [], {
                animateParam: animateParam,
                scene: MetaballAnimationScene.NORMAL
            });

            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);
        });

        it('should_call_fusionBall_with_correct_parameters1', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let mockGetAnimateParam: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            let mockFusionBall: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);

            let animateParam: AnimateParam = new AnimateParam();
            when(mockGetAnimateParam)([]).afterReturn(animateParam);

            when(mockFusionBall)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean],
                ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterReturn(Promise.resolve());

            await liveThreeMetaballVm.toggleState();

            expect(mockFusionBall).assertCalledWith([true, true, true], [], {
                animateParam: animateParam,
                scene: MetaballAnimationScene.NORMAL
            });

            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);
        });

        it('should_log_error_when_fusionBall_throws_error', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let mockGetAnimateParam: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            let mockFusionBall: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);

            let animateParam: AnimateParam = new AnimateParam();
            when(mockGetAnimateParam)([]).afterReturn(animateParam);

            when(mockFusionBall)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean],
                ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error message");

            await liveThreeMetaballVm.toggleState();

            expect(LogHelper.error).assertCalledWith(LogDomain.LIVE, "Error in LiveThreeMetaBallVm toggleState: Error message");

            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);
        });

        it('should_log_error_when_fusionBall_throws_error2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let mockGetAnimateParam: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            let mockFusionBall: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);

            let animateParam: AnimateParam = new AnimateParam();
            when(mockGetAnimateParam)([]).afterReturn(animateParam);

            when(mockFusionBall)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean],
                ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error message");

            await liveThreeMetaballVm.toggleState();

            expect(LogHelper.error).assertCalledWith(LogDomain.LIVE, "Error in LiveThreeMetaBallVm toggleState: Error message");

            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);
        });

        it('should_set_status_bar_position_to_center_when_fusionBall_returns_undefined', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let mockGetAnimateParam: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            let mockFusionBall: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);

            let animateParam: AnimateParam = new AnimateParam();
            when(mockGetAnimateParam)([]).afterReturn(animateParam);

            when(mockFusionBall)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean],
                ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterReturn(undefined);

            await liveThreeMetaballVm.toggleState();

            expect(liveThreeMetaballVm.statusBarCapsulePosition).assertEqual(StatusBarCapsulePosition.CENTER);

            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);
        });

        it('should_set_status_bar_position_to_center_when_fusionBall_returns_undefined3', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveThreeMetaballVm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let mockGetAnimateParam: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            let mockFusionBall: Function = mocker.mockFunc(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);

            let animateParam: AnimateParam = new AnimateParam();
            when(mockGetAnimateParam)([]).afterReturn(animateParam);

            when(mockFusionBall)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean],
                ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterReturn(undefined);

            await liveThreeMetaballVm.toggleState();

            expect(liveThreeMetaballVm.statusBarCapsulePosition).assertEqual(StatusBarCapsulePosition.CENTER);

            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.getAnimateParam);
            mocker.ignoreMock(liveThreeMetaballVm, liveThreeMetaballVm.fusionBall);
        });
    });

    describe('getWidth_testSuite', () => {
        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_return_correct_width', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = 2;
            livethreemetaballvm.getWidth(capsulePosition);
            expect(livethreemetaballvm.getWidth(capsulePosition)).assertEqual(200);
        });

        it('should_return_zero_when_widthFactor_is_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = 0;
            livethreemetaballvm.getWidth(capsulePosition);
            expect(livethreemetaballvm.getWidth(capsulePosition)).assertEqual(0);
        });

        it('should_return_negative_when_widthFactor_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = -2;
            livethreemetaballvm.getWidth(capsulePosition);
            expect(livethreemetaballvm.getWidth(capsulePosition)).assertEqual(-200);
        });

        it('should_return_zero_when_capsulePosition_is_null', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = null;
            let widthFactor: number = 2;
            livethreemetaballvm.getWidth(capsulePosition);
            expect(livethreemetaballvm.getWidth(capsulePosition)).assertEqual(0);
        });

        it('should_return_correct_width', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = 2;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertEqual(200);
        });

        it('should_return_zero_when_widthFactor_is_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = 0;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_negative_when_widthFactor_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = -2;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertEqual(-200);
        });

        it('should_return_zero_when_capsulePosition_is_null', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = null;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_zero_when_capsulePosition_width_is_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 0;
            let widthFactor: number = 2;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_correct_width_with_negative_capsulePosition_width', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = -100;
            let widthFactor: number = 2;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertEqual(-200);
        });

        it('should_return_NaN_when_capsulePosition_width_is_NaN', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = NaN;
            let widthFactor: number = 2;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertNaN();
        });

        it('should_return_NaN_when_widthFactor_is_NaN', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.width = 100;
            let widthFactor: number = NaN;
            let result = livethreemetaballvm.getWidth(capsulePosition);
            expect(result).assertNaN();
        });
    });

    describe('getHeight_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_height', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertEqual(100 * livethreemetaballvm.heightFactor);
        });

        it('should_return_zero_when_capsulePosition_is_null', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let result = livethreemetaballvm.getHeight(null);
            expect(result).assertEqual(0);
        });

        it('should_return_correct_height_when_heightFactor_is_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            livethreemetaballvm.heightFactor = 0;
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_correct_height_when_heightFactor_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            livethreemetaballvm.heightFactor = -2;
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertEqual(-200);
        });

        it('should_return_correct_height_when_heightFactor_is_positive', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            livethreemetaballvm.heightFactor = 2;
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertEqual(200);
        });

        it('should_return_zero_when_capsulePosition_is_undefined', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            const result = livethreemetaballvm.getHeight(undefined);
            expect(result).assertEqual(0);
        });

        it('should_return_NaN_when_capsulePosition_height_is_null', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            const capsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = null;
            const result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertNaN();
        });

        it('should_return_NaN_when_capsulePosition_height_is_undefined', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            const capsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = undefined;
            const result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertNaN();
        });

        it('should_return_negative_height_when_height_is_negative_and_heightFactor_positive', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            const capsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -100;
            const result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertLess(0);
        });

        it('should_return_positive_height_when_height_and_heightFactor_are_negative', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            livethreemetaballvm.heightFactor = -1;
            const capsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -100;
            const result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertLarger(0);
        });

        it('should_return_zero_when_capsulePosition_height_is_zero', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            const capsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            const result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertEqual(0);
        });

        it('should_return_correct_height_with_decimal_heightFactor', 0, () => {
            const livethreemetaballvm = new LiveThreeMetaBallVm();
            livethreemetaballvm.heightFactor = 0.5;
            const capsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 200;
            const result = livethreemetaballvm.getHeight(capsulePosition);
            expect(result).assertEqual(100);
        });
    });

    describe('getPosition_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_position_when_capsulePosition_is_valid', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(-capsulePosition.height * (LiveStyle.HEIGHT_FACTOR - 1) / 2);
        });

        it('should_return_position_with_zero_when_capsulePosition_height_is_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_position_with_negative_height_when_capsulePosition_height_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -100;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(-capsulePosition.height * (LiveStyle.HEIGHT_FACTOR - 1) / 2);
        });

        it('should_return_correct_position_when_capsulePosition_is_valid', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 100;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(-capsulePosition.height * (LiveStyle.HEIGHT_FACTOR - 1) / 2);
        });

        it('should_return_position_with_zero_when_capsulePosition_height_is_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = 0;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_position_with_negative_height_when_capsulePosition_height_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = -100;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(-capsulePosition.height * (LiveStyle.HEIGHT_FACTOR - 1) / 2);
        });

        it('should_return_default_position_when_capsulePosition_is_null', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = null;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_position_with_zero_when_capsulePosition_height_is_undefined', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            delete capsulePosition.height;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });

        it('should_return_position_with_zero_when_capsulePosition_height_is_non_number', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.height = "invalid" as any;
            let result: Edges = livethreemetaballvm.getPosition(capsulePosition);
            expect(result.top).assertEqual(0);
        });
    });

    describe('getBallParam_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_return_correct_ball_params_when_capsule_position_is_valid', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 25 },
                { centerX: 20, centerY: 30 },
                { centerX: 25, centerY: 35 }
            ];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_empty_array_when_capsule_position_is_null', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let result: BallParams[] = livethreemetaballvm.getBallParam(null);
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_has_no_holes', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(0);
        });

        it('should_return_correct_ball_params_when_capsule_position_is_valid', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 25 },
                { centerX: 20, centerY: 30 },
                { centerX: 25, centerY: 35 }
            ];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_return_empty_array_when_capsule_position_is_null', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let result: BallParams[] = livethreemetaballvm.getBallParam(null);
            expect(result.length).assertEqual(0);
        });

        it('should_return_empty_array_when_capsule_position_has_no_holes', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(0);
        });

        it('should_return_two_ball_params_when_capsule_position_has_two_holes', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 15, centerY: 25 },
                { centerX: 20, centerY: 30 }
            ];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(2);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
        });

        it('should_calculate_negative_center_x_when_left_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = -5;
            capsulePosition.top = 20;
            capsulePosition.holes = [
                { centerX: 10, centerY: 25 },
                { centerX: 15, centerY: 30 },
                { centerX: 20, centerY: 35 }
            ];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(15);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(20);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(25);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_calculate_negative_center_y_when_top_is_negative', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 10;
            capsulePosition.top = -5;
            capsulePosition.holes = [
                { centerX: 15, centerY: 20 },
                { centerX: 20, centerY: 25 },
                { centerX: 25, centerY: 30 }
            ];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(5);
            expect(result[0].centerY).assertEqual(25);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(10);
            expect(result[1].centerY).assertEqual(30);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(15);
            expect(result[2].centerY).assertEqual(35);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });

        it('should_calculate_center_when_left_and_top_are_zero', 0, () => {
            let livethreemetaballvm: LiveThreeMetaBallVm = new LiveThreeMetaBallVm();
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            capsulePosition.left = 0;
            capsulePosition.top = 0;
            capsulePosition.holes = [
                { centerX: 10, centerY: 20 },
                { centerX: 15, centerY: 25 },
                { centerX: 20, centerY: 30 }
            ];
            let result: BallParams[] = livethreemetaballvm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(3);
            expect(result[0].centerX).assertEqual(10);
            expect(result[0].centerY).assertEqual(20);
            expect(result[0].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[0].isIsolated).assertTrue();
            expect(result[1].centerX).assertEqual(15);
            expect(result[1].centerY).assertEqual(25);
            expect(result[1].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[1].isIsolated).assertTrue();
            expect(result[2].centerX).assertEqual(20);
            expect(result[2].centerY).assertEqual(30);
            expect(result[2].radius).assertEqual(LiveStyle.CAPSULE_HEIGHT / 2);
            expect(result[2].isIsolated).assertTrue();
        });
    });
}