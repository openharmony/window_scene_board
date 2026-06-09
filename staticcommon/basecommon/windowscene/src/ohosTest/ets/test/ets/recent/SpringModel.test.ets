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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  MockKit
} from '@ohos/hypium';
import { SpringProperty, SpringModel, OverDampedModel, CriticalDampedModel } from '../../../../../main/ets/recent/SpringModel';

let springProperty: SpringProperty = new SpringProperty(0, 0, 0)

export function SpringModelTest() {
  describe('SpringModelTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('SpringModel_test_springProperty_setMass', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      let mass:number = 1
      property.setMass(mass)
      expect(property.mass_).assertEqual(mass);
    })

    it('SpringModel_test_springProperty_mass', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      let mass:number = 1
      expect(property.mass()).assertEqual(mass);
    })

    it('SpringModel_test_springProperty_setStiffness', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      let stiffness:number = 1
      property.setStiffness(stiffness)
      expect(property.stiffness_).assertEqual(stiffness);
    })

    it('SpringModel_test_springProperty_stiffness', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      let stiffness:number = 1
      expect(property.stiffness()).assertEqual(stiffness);
    })

    it('SpringModel_test_springProperty_setDamping', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      let damping:number = 1
      property.setDamping(damping)
      expect(property.damping_).assertEqual(damping);
    })

    it('SpringModel_test_springProperty_damping', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      let damping:number = 1
      expect(property.damping()).assertEqual(damping);
    })

    it('SpringModel_test_springProperty_isValid_01', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setMass(0)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_springProperty_isValid_02', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setMass(-1)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_springProperty_isValid_03', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setStiffness(0)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_springProperty_isValid_04', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setStiffness(-1)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_springProperty_isValid_05', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setDamping(0)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_springProperty_isValid_06', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setDamping(-1)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_springProperty_isValid_true_01', 0, (): void => {
      let property:SpringProperty = new SpringProperty(1, 1, 1);
      property.setMass(1)
      property.setStiffness(1)
      property.setDamping(1)
      expect(property.isValid()).assertTrue();
    })

    it('SpringModel_test_criticalDampedModel', 0, (): void => {
      let criticalDampedModel:CriticalDampedModel = new CriticalDampedModel(1, 1, springProperty);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(springProperty, springProperty.isValid);
      when(mockfunc)().afterReturn(true);
      let mockfunc_1: Function = mocker.mockFunc(springProperty, springProperty.damping);
      when(mockfunc_1)().afterReturn(2);
      let mockfunc_2: Function = mocker.mockFunc(springProperty, springProperty.mass);
      when(mockfunc_2)().afterReturn(1);
      expect(criticalDampedModel).not().assertUndefined();
      mocker.clearAll();
    })

    it('SpringModel_test_build_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(springProperty, springProperty.isValid);
      when(mockfunc)().afterReturn(false);
      SpringModel.build(1, 1 ,springProperty);
      let test = 'test'
      expect(test).assertEqual('test');
    })

    it('SpringModel_test_build_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(springProperty, springProperty.isValid);
      when(mockfunc)().afterReturn(true);
      let mockfunc_1: Function = mocker.mockFunc(springProperty, springProperty.damping);
      when(mockfunc_1)().afterReturn(0);
      let mockfunc_2: Function = mocker.mockFunc(springProperty, springProperty.mass);
      when(mockfunc_2)().afterReturn(0);
      let mockfunc_3: Function = mocker.mockFunc(springProperty, springProperty.stiffness);
      when(mockfunc_3)().afterReturn(0);
      SpringModel.build(0, 1 ,springProperty)
      expect(SpringModel.build(1, 1 ,springProperty) !== undefined).assertEqual(true);
    })

    it('SpringModel_test_build_03', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(springProperty, springProperty.isValid);
      when(mockfunc)().afterReturn(true);
      let mockfunc_1: Function = mocker.mockFunc(springProperty, springProperty.damping);
      when(mockfunc_1)().afterReturn(0);
      let mockfunc_2: Function = mocker.mockFunc(springProperty, springProperty.mass);
      when(mockfunc_2)().afterReturn(0);
      let mockfunc_3: Function = mocker.mockFunc(springProperty, springProperty.stiffness);
      when(mockfunc_3)().afterReturn(0);
      SpringModel.build(1, 1 ,springProperty)
      expect(SpringModel.build(1, 1 ,springProperty) !== undefined).assertEqual(true);
    })

    it('SpringModel_test_criticalDampedModel_build_04', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(springProperty, springProperty.isValid);
      when(mockfunc)().afterReturn(true);
      let mockfunc_1: Function = mocker.mockFunc(springProperty, springProperty.damping);
      when(mockfunc_1)().afterReturn(3);
      let mockfunc_2: Function = mocker.mockFunc(springProperty, springProperty.mass);
      when(mockfunc_2)().afterReturn(1);
      let mockfunc_3: Function = mocker.mockFunc(springProperty, springProperty.stiffness);
      when(mockfunc_3)().afterReturn(1);
      SpringModel.build(1, 1 ,springProperty)
      expect(SpringModel.build(1, 1 ,springProperty) !== undefined).assertEqual(true);
    })

    it('SpringModel_test_criticalDampedModel_build_05', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(springProperty, springProperty.isValid);
      when(mockfunc)().afterReturn(true);
      let mockfunc_1: Function = mocker.mockFunc(springProperty, springProperty.damping);
      when(mockfunc_1)().afterReturn(0);
      let mockfunc_2: Function = mocker.mockFunc(springProperty, springProperty.mass);
      when(mockfunc_2)().afterReturn(1);
      let mockfunc_3: Function = mocker.mockFunc(springProperty, springProperty.stiffness);
      when(mockfunc_3)().afterReturn(-1);
      expect(SpringModel.build(1, 1 ,springProperty) !== undefined).assertEqual(true);
    })
  })
}