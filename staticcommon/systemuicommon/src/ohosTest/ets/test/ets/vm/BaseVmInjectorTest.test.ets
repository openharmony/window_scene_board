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
import { SystemUIUseScene } from '../../../main/ets/constants/SystemuiConstants';
import { SystemUIColorVm } from '../../../main/ets/vm/SystemUIColorVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { BaseVmInjector } from '../../../main/ets/vm/BaseVmInjector';
export default function BaseVmInjectorTest() {
  describe('getColorVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = undefined;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_empty_string', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = '';
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_invalid_value', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = 12345;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_true_when_vmMap_has_key', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      let key: string = "testKey";
      let value: SystemUIColorVm = new SystemUIColorVm(SystemUIUseScene.LOCKSCREEN);
      vmMap.set(key, value);
      basevminjector.vmMap = vmMap;
      const result = basevminjector.hasVm(key);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_vmMap_does_not_have_key', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      let key: string = "testKey";
      basevminjector.vmMap = vmMap;
      const result = basevminjector.hasVm(key);
      expect(result).assertEqual(false);
    });

    it('should_add_vm_to_map_when_key_is_unique', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm: SystemUIColorVm = new SystemUIColorVm();
      basevminjector.updateVm('uniqueKey', vm);
      expect(basevminjector.vmMap.has('uniqueKey')).assertTrue();
      expect(basevminjector.vmMap.get('uniqueKey')).assertDeepEquals(vm);
    });

    it('should_replace_vm_in_map_when_key_already_exists', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm1: SystemUIColorVm = new SystemUIColorVm();
      let vm2: SystemUIColorVm = new SystemUIColorVm();
      basevminjector.updateVm('existingKey', vm1);
      basevminjector.updateVm('existingKey', vm2);
      expect(basevminjector.vmMap.has('existingKey')).assertTrue();
      expect(basevminjector.vmMap.get('existingKey')).assertDeepEquals(vm2);
    });

    it('should_throw_error_when_key_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm: SystemUIColorVm = new SystemUIColorVm();
      expect(() => basevminjector.updateVm(null, vm)).assertThrowError('Error: key is null');
    });

    it('should_throw_error_when_vm_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      expect(() => basevminjector.updateVm('key', null)).assertThrowError('Error: vm is null');
    });

    it('should_clear_vmMap_when_clearVm_is_called', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      vmMap.set('testKey', 'testValue');
      basevminjector.vmMap = vmMap;
      basevminjector.clearVm();
      expect(basevminjector.vmMap.size).assertEqual(0);
    });

    it('should_do_nothing_when_vmMap_is_already_empty', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.clearVm();
      expect(basevminjector.vmMap.size).assertEqual(0);
    });

    it('should_throw_error_when_scene_is_not_set', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      expect(() => basevminjector.clearVm()).assertThrowError('scene is not set');
    });

    it('should_throw_error_when_scene_is_not_valid', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.INVALID;
      expect(() => basevminjector.clearVm()).assertThrowError('scene is not valid');
    });

    it('should_return_correct_id_when_id_is_valid', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_empty', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = "";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = null;
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = undefined;
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = undefined;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_custom', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.CUSTOM;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.CUSTOM}]${id}`);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = undefined;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_empty_string', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = '';
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_invalid_value', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = 12345;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_true_when_vmMap_has_key', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      let key: string = "testKey";
      let value: SystemUIColorVm = new SystemUIColorVm(SystemUIUseScene.LOCKSCREEN);
      vmMap.set(key, value);
      basevminjector.vmMap = vmMap;
      const result = basevminjector.hasVm(key);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_vmMap_does_not_have_key', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      let key: string = "testKey";
      basevminjector.vmMap = vmMap;
      const result = basevminjector.hasVm(key);
      expect(result).assertEqual(false);
    });

    it('should_add_vm_to_map_when_key_is_unique', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm: SystemUIColorVm = new SystemUIColorVm();
      basevminjector.updateVm('uniqueKey', vm);
      expect(basevminjector.vmMap.has('uniqueKey')).assertTrue();
      expect(basevminjector.vmMap.get('uniqueKey')).assertDeepEquals(vm);
    });

    it('should_replace_vm_in_map_when_key_already_exists', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm1: SystemUIColorVm = new SystemUIColorVm();
      let vm2: SystemUIColorVm = new SystemUIColorVm();
      basevminjector.updateVm('existingKey', vm1);
      basevminjector.updateVm('existingKey', vm2);
      expect(basevminjector.vmMap.has('existingKey')).assertTrue();
      expect(basevminjector.vmMap.get('existingKey')).assertDeepEquals(vm2);
    });

    it('should_throw_error_when_key_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm: SystemUIColorVm = new SystemUIColorVm();
      expect(() => basevminjector.updateVm(null, vm)).assertThrowError('Error: key is null');
    });

    it('should_throw_error_when_vm_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      expect(() => basevminjector.updateVm('key', null)).assertThrowError('Error: vm is null');
    });

    it('should_clear_vmMap_when_clearVm_is_called', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      vmMap.set('testKey', 'testValue');
      basevminjector.vmMap = vmMap;
      basevminjector.clearVm();
      expect(basevminjector.vmMap.size).assertEqual(0);
    });

    it('should_do_nothing_when_vmMap_is_already_empty', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.clearVm();
      expect(basevminjector.vmMap.size).assertEqual(0);
    });

    it('should_throw_error_when_scene_is_not_set', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      expect(() => basevminjector.clearVm()).assertThrowError('scene is not set');
    });

    it('should_throw_error_when_scene_is_not_valid', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.INVALID;
      expect(() => basevminjector.clearVm()).assertThrowError('scene is not valid');
    });

    it('should_return_correct_id_when_id_is_valid', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_empty', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = "";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = null;
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = undefined;
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = undefined;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_custom', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.CUSTOM;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.CUSTOM}]${id}`);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = undefined;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_empty_string', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = '';
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_SystemUIColorVm_instance_when_getColorVm_is_called_with_scene_as_invalid_value', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = 12345;
      const result = basevminjector.getColorVm();
      expect(result).assertEqual(SystemUIColorVm.instance);
    });

    it('should_return_true_when_vmMap_has_key', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      let key: string = "testKey";
      let value: SystemUIColorVm = new SystemUIColorVm(SystemUIUseScene.LOCKSCREEN);
      vmMap.set(key, value);
      basevminjector.vmMap = vmMap;
      const result = basevminjector.hasVm(key);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_vmMap_does_not_have_key', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      let key: string = "testKey";
      basevminjector.vmMap = vmMap;
      const result = basevminjector.hasVm(key);
      expect(result).assertEqual(false);
    });

    it('should_add_vm_to_map_when_key_is_unique', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm: SystemUIColorVm = new SystemUIColorVm();
      basevminjector.updateVm('uniqueKey', vm);
      expect(basevminjector.vmMap.has('uniqueKey')).assertTrue();
      expect(basevminjector.vmMap.get('uniqueKey')).assertDeepEquals(vm);
    });

    it('should_replace_vm_in_map_when_key_already_exists', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm1: SystemUIColorVm = new SystemUIColorVm();
      let vm2: SystemUIColorVm = new SystemUIColorVm();
      basevminjector.updateVm('existingKey', vm1);
      basevminjector.updateVm('existingKey', vm2);
      expect(basevminjector.vmMap.has('existingKey')).assertTrue();
      expect(basevminjector.vmMap.get('existingKey')).assertDeepEquals(vm2);
    });

    it('should_throw_error_when_key_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vm: SystemUIColorVm = new SystemUIColorVm();
      expect(() => basevminjector.updateVm(null, vm)).assertThrowError('Error: key is null');
    });

    it('should_throw_error_when_vm_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      expect(() => basevminjector.updateVm('key', null)).assertThrowError('Error: vm is null');
    });

    it('should_clear_vmMap_when_clearVm_is_called', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      let vmMap: Map<string, Object> = new Map();
      vmMap.set('testKey', 'testValue');
      basevminjector.vmMap = vmMap;
      basevminjector.clearVm();
      expect(basevminjector.vmMap.size).assertEqual(0);
    });

    it('should_do_nothing_when_vmMap_is_already_empty', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.clearVm();
      expect(basevminjector.vmMap.size).assertEqual(0);
    });

    it('should_throw_error_when_scene_is_not_set', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      expect(() => basevminjector.clearVm()).assertThrowError('scene is not set');
    });

    it('should_throw_error_when_scene_is_not_valid', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.INVALID;
      expect(() => basevminjector.clearVm()).assertThrowError('scene is not valid');
    });

    it('should_return_correct_id_when_id_is_valid', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_empty', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = "";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = null;
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_id_is_undefined', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = SystemUIUseScene.DEFAULT;
      let id: string = undefined;
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });

    it('should_return_correct_id_when_scene_is_null', 0, () => {
      let basevminjector: BaseVmInjector = new BaseVmInjector();
      basevminjector.scene = null;
      let id: string = "12345";
      let result: string = basevminjector.getId(id);
      expect(result).assertEqual(`[${SystemUIUseScene.DEFAULT}]${id}`);
    });
  });
