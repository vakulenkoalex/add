
import shutil
import os

GIT = os.getcwd()
print(GIT)

if __name__ == '__main__':

    dict = {}
    dict[os.path.join('build', 'epf')] = ''
    dict[os.path.join('build','plugins')] = 'plugins'
    dict[os.path.join('build','vendor')] = 'vendor'
    dict[os.path.join('build','tools', 'epf')] = os.path.join('tools', 'epf')
    dict[os.path.join('build','features', 'libraries')] = os.path.join('features', 'libraries')
    dict[os.path.join('build','lib', 'featurereader')] = os.path.join('lib', 'featurereader')
    dict[os.path.join('build','lib', 'video')] = os.path.join('lib', 'video')

    for path_src, path_dst in dict.items():
        for root, dirs, files in os.walk(os.path.join(GIT, path_src)):
            for file in files:
                if file.endswith('.epf'):

                    full_path_src = os.path.join(root, file)
                    full_path_dst = os.path.join(os.path.split(root)[0].replace(path_src, path_dst), file)
                    print(full_path_src + ' - ' + full_path_dst)

                    shutil.copy(full_path_src, full_path_dst)