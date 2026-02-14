/**
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

const { execSync } = require('child_process');
const path = require('path');

const rootPath = path.resolve(__dirname, '..');
const idePath = path.resolve(process.env.DEVECO_SDK_HOME, '..');
const nodePath = path.resolve(idePath, 'tools/node');
const npmPath = path.resolve(nodePath, 'npm');

execSync(`"${npmPath}" i`, {
  cwd: rootPath,
  stdio: 'inherit',
});

const execa = require('execa');
const { getEscapedCommand } = require('execa/lib/command');
const iconv = require('iconv-lite');

module.exports = class CommandUtil {
  /**
   * 执行命令，执行结果输出到控制台
   * @param command 命令
   * @param options 命令选项
   * @returns 执行结果
   */
  static async run(command, options) {
    const file = command[0];
    const args = command.slice(1);

    if (!options?.silent) {
      console.info('run command: ' + getEscapedCommand(file, args));
    }

    const result = await execa(file, args, {
      encoding: null,
      reject: false,
      stderr: process.stderr,
      stdout: process.stdout,
      ...options,
    });

    return this.decode(result);
  }

  /**
   * 执行命令并返回结果
   * @param {*} command 
   * @param {*} options 
   * @returns 
   */
  static async runWithOutput(command, options) {
    return this.run(command, { ...options, stderr: undefined, stdout: undefined });
  }

  /**
   * 同步执行命令
   * @param command 命令
   * @param options 命令选项
   * @returns 执行结果
   */
  static runSync(command, options) {
    const file = command[0];
    const args = command.slice(1);

    if (!options?.silent) {
      console.info('run command: ' + getEscapedCommand(file, args));
    }

    const result = execa.sync(file, args, {
      encoding: null,
      ...options,
    });

    return this.decode(result);
  }

  /**
   * 对命令执行结果进行解码
   * @param result 命令执行结果
   * @returns 解码后的输出字符串
   */
  static decode(result) {
    if (!result.stdout && !result.stderr) {
      return result.message;
    }

    const buffer = result.failed && !result.stdout?.length && result.stderr.length
      ? result.stderr
      : result.stdout;
    return this.decodeBuffer(buffer);
  }

  /**
   * 将控制台输出的Buffer转成字符串
   * @param buffer
   * @returns
   */
  static decodeBuffer(buffer) {
    if (process.platform === 'win32') {
      return iconv.decode(buffer, 'cp936');
    }
    return iconv.decode(buffer, 'utf-8');
  }
};