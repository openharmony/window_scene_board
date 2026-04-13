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
import { StatusBarCapsulePosition } from '../../../../../../main/ets/statusbar/model/StatusBarCapsulePosition';
import { ILiveMetaBallVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVm';
import { LiveMetaBallBaseVm } from '../../../../../../main/ets/live/vm/LiveMetaBallBaseVm';
import { BallParams } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveZeroMetaBallVm } from '../../../../../../main/ets/live/vm/LiveZeroMetaBallVm';
import { LiveVmInjector } from '../../../../../../../newIndex';

export default function LiveZeroMetaBallVmTest() {
    describe('getWidth_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_width', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            let capsulePosition = new StatusBarCapsulePosition();
            let result = liveZeroMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_width2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            let capsulePosition = new StatusBarCapsulePosition();
            let result = liveZeroMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getHeight_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let result = liveZeroMetaballVm.getHeight(new StatusBarCapsulePosition());
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_log_warning_when_using_LiveZeroMetaBallVm2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let result = liveZeroMetaballVm.getHeight(new StatusBarCapsulePosition());
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getPosition_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_position', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            const result = liveZeroMetaballVm.getPosition(capsulePosition);

            expect(result).assertDeepEquals({
                left: 0,
                top: 0
            });

            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_position2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            const result = liveZeroMetaballVm.getPosition(capsulePosition);

            expect(result).assertDeepEquals({
                left: 0,
                top: 0
            });

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getBallParam_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_return_ball_params_when_capsulePosition_is_valid', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            const result = liveZeroMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(1);
            expect(result[0].centerX).assertEqual(0);
            expect(result[0].centerY).assertEqual(0);
            expect(result[0].radius).assertEqual(0);
            expect(result[0].isIsolated).assertEqual(true);

            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_return_ball_params_when_capsulePosition_is_valid2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            const result = liveZeroMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(1);
            expect(result[0].centerX).assertEqual(0);
            expect(result[0].centerY).assertEqual(0);
            expect(result[0].radius).assertEqual(0);
            expect(result[0].isIsolated).assertEqual(true);

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('toggleState_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_log_warning_when_toggleState_is_called', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let logHelper: LogHelper = LogHelper.INSTANCE;
            let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            await liveZeroMetaballVm.toggleState();

            mocker.ignoreMock(logHelper, logHelper.showWarn);
        });

        it('should_log_warning_when_toggleState_is_called2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let logHelper: LogHelper = LogHelper.INSTANCE;
            let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            await liveZeroMetaballVm.toggleState();

            mocker.ignoreMock(logHelper, logHelper.showWarn);
        });
    });

    describe('getWidth_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_width', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            let capsulePosition = new StatusBarCapsulePosition();
            let result = liveZeroMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getHeight_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let result = liveZeroMetaballVm.getHeight(new StatusBarCapsulePosition());
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getPosition_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_position', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            const result = liveZeroMetaballVm.getPosition(capsulePosition);

            expect(result).assertDeepEquals({
                left: 0,
                top: 0
            });

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getBallParam_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_return_ball_params_when_capsulePosition_is_valid', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            const result = liveZeroMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(1);
            expect(result[0].centerX).assertEqual(0);
            expect(result[0].centerY).assertEqual(0);
            expect(result[0].radius).assertEqual(0);
            expect(result[0].isIsolated).assertEqual(true);

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('toggleState_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_log_warning_when_toggleState_is_called', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let logHelper: LogHelper = LogHelper.INSTANCE;
            let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            await liveZeroMetaballVm.toggleState();

            mocker.ignoreMock(logHelper, logHelper.showWarn);
        });
    });
    describe('getWidth_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_width', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            let capsulePosition = new StatusBarCapsulePosition();
            let result = liveZeroMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_width2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            let capsulePosition = new StatusBarCapsulePosition();
            let result = liveZeroMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getHeight_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let result = liveZeroMetaballVm.getHeight(new StatusBarCapsulePosition());
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_log_warning_when_using_LiveZeroMetaBallVm2', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let result = liveZeroMetaballVm.getHeight(new StatusBarCapsulePosition());
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getPosition_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_position', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            const result = liveZeroMetaballVm.getPosition(capsulePosition);

            expect(result).assertDeepEquals({
                left: 0,
                top: 0
            });

            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_position2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            const result = liveZeroMetaballVm.getPosition(capsulePosition);

            expect(result).assertDeepEquals({
                left: 0,
                top: 0
            });

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getBallParam_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_return_ball_params_when_capsulePosition_is_valid', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            const result = liveZeroMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(1);
            expect(result[0].centerX).assertEqual(0);
            expect(result[0].centerY).assertEqual(0);
            expect(result[0].radius).assertEqual(0);
            expect(result[0].isIsolated).assertEqual(true);

            mocker.ignoreMock(LogHelper, log.showWarn);
        });

        it('should_return_ball_params_when_capsulePosition_is_valid2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            const result = liveZeroMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(1);
            expect(result[0].centerX).assertEqual(0);
            expect(result[0].centerY).assertEqual(0);
            expect(result[0].radius).assertEqual(0);
            expect(result[0].isIsolated).assertEqual(true);

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('toggleState_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_log_warning_when_toggleState_is_called', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let logHelper: LogHelper = LogHelper.INSTANCE;
            let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            await liveZeroMetaballVm.toggleState();

            mocker.ignoreMock(logHelper, logHelper.showWarn);
        });

        it('should_log_warning_when_toggleState_is_called2', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let logHelper: LogHelper = LogHelper.INSTANCE;
            let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            await liveZeroMetaballVm.toggleState();

            mocker.ignoreMock(logHelper, logHelper.showWarn);
        });
    });

    describe('getWidth_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_width', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            let capsulePosition = new StatusBarCapsulePosition();
            let result = liveZeroMetaballVm.getWidth(capsulePosition);
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getHeight_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm', 0, () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let result = liveZeroMetaballVm.getHeight(new StatusBarCapsulePosition());
            expect(result).assertEqual(0);
            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getPosition_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });


        it('should_log_warning_when_using_LiveZeroMetaBallVm_to_get_position', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            const result = liveZeroMetaballVm.getPosition(capsulePosition);

            expect(result).assertDeepEquals({
                left: 0,
                top: 0
            });

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('getBallParam_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_return_ball_params_when_capsulePosition_is_valid', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
            let mocker: MockKit = new MockKit();
            const TAG = 'LiveZeroMetaBallVmTest';
            const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
            let mockfunc: Function = mocker.mockFunc(LogHelper, log.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

            const result = liveZeroMetaballVm.getBallParam(capsulePosition);
            expect(result.length).assertEqual(1);
            expect(result[0].centerX).assertEqual(0);
            expect(result[0].centerY).assertEqual(0);
            expect(result[0].radius).assertEqual(0);
            expect(result[0].isIsolated).assertEqual(true);

            mocker.ignoreMock(LogHelper, log.showWarn);
        });
    });

    describe('toggleState_testSuite', () => {

        beforeEach(() => {

        });
        afterEach(() => {

        });

        it('should_log_warning_when_toggleState_is_called', 0, async () => {
            let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
            let liveZeroMetaballVm: LiveZeroMetaBallVm = new LiveZeroMetaBallVm(liveVmInjector);
            let mocker: MockKit = new MockKit();
            let logHelper: LogHelper = LogHelper.INSTANCE;
            let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            await liveZeroMetaballVm.toggleState();

            mocker.ignoreMock(logHelper, logHelper.showWarn);
        });

        it('should_logInfo_when_isShow_is_false', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            livecapsulevm.isShow = false;
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
            when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
            livecapsulevm.onClick();
            mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        });


        it('should_startCapsuleWantAgent_when_isInstant_is_true', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            livecapsulevm.isShow = true;
            livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => true } as LiveItemBaseVm;
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
            when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturnNothing();
            livecapsulevm.onClick();
            mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
        });


        it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_need_expand', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            livecapsulevm.isShow = true;
            livecapsulevm.isPersistent = true;
            livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
            livecapsulevm.checkNeedExpandCard = () => false;
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
            when(mockfunc)().afterReturnNothing();
            livecapsulevm.onClick();
            mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
        });


        it('should_startCapsuleWantAgent_when_isPersistent_is_true_and_need_expand_and_wantAgent_exists', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            livecapsulevm.isShow = true;
            livecapsulevm.isPersistent = true;
            livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: true } as LiveItemBaseVm;
            livecapsulevm.checkNeedExpandCard = () => true;
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
            when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();
            livecapsulevm.onClick();
            mocker.ignoreMock(livecapsulevm.vmInjector.getStarterVm(), livecapsulevm.vmInjector.getStarterVm().startCapsuleWantAgent);
        });


        it('should_expandCapsuleToCard_when_isPersistent_is_true_and_no_wantAgent_and_need_expand', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            livecapsulevm.isShow = true;
            livecapsulevm.isPersistent = true;
            livecapsulevm.live = { type: LiveType.VIDEO_LIVING, isInstant: () => false, wantAgent: false } as LiveItemBaseVm;
            livecapsulevm.checkNeedExpandCard = () => true;
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
            when(mockfunc)().afterReturnNothing();
            livecapsulevm.onClick();
            mocker.ignoreMock(livecapsulevm.vmInjector.getSwitchVm(), livecapsulevm.vmInjector.getSwitchVm().expandCapsuleToCard);
        });

        it('should_log_error_when_button_is_null', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            livecapsulevm.button = null;
            livecapsulevm.onClickButton();

            mocker.ignoreMock(LogHelper, LogHelper.showError);
        });

        it('should_save_info_and_trigger_button_when_button_is_not_null', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            let mockButton = { name: 'testButton' };
            livecapsulevm.button = mockButton as any;

            let mockStartVm = { triggerButton: () => {} };
            let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
            when(mockGetStartVm)().afterReturn(mockStartVm);

            livecapsulevm.onClickButton();

            mocker.ignoreMock(LogHelper, LogHelper.showError);
            mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
        });

        it('should_report_record_click_event_when_live_is_screen_recorder', 0, () => {
            let livecapsulevm: LiveCapsuleVm = new LiveCapsuleVm();
            let mocker: MockKit = new MockKit();
            let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
            when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

            let mockButton = { name: 'testButton' };
            livecapsulevm.button = mockButton as any;

            let mockStartVm = { triggerButton: () => {} };
            let mockGetStartVm = mocker.mockFunc(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
            when(mockGetStartVm)().afterReturn(mockStartVm);

            let mockIsScreenRecorder = mocker.mockFunc(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
            when(mockIsScreenRecorder)().afterReturn(true);

            livecapsulevm.onClickButton();

            mocker.ignoreMock(LogHelper, LogHelper.showError);
            mocker.ignoreMock(livecapsulevm.vmInjector, livecapsulevm.vmInjector.getStarterVm);
            mocker.ignoreMock(livecapsulevm.live, livecapsulevm.live.isScreenRecorder);
        });
    });
}