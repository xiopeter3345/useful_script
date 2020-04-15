#! /usr/bin/python

import subprocess
import sys
import os

java_code = """
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.alias.CredentialProvider;
import org.apache.hadoop.security.alias.CredentialProviderFactory;

import java.util.List;

public class Test {

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        conf.set(CredentialProviderFactory.CREDENTIAL_PROVIDER_PATH,
                args[0]);
        CredentialProvider provider = CredentialProviderFactory.getProviders(conf).get(0);
        List<String> aliases = provider.getAliases();
        for(int i = 0; i < aliases.size(); i++) {
            System.out.println("Entry " + (i + 1));
            System.out.println("============================================");
            System.out.println("Alias: " + aliases.get(i));
            CredentialProvider.CredentialEntry entry = provider.getCredentialEntry(aliases.get(i));
            if(entry != null) {
                String credential = new String(entry.getCredential());
                System.out.println("Credential: " + credential);
            }
            System.out.println("============================================\\n\\n");
        }

    }

}
"""

def main():
    if len(sys.argv) != 2:
        print("Usage: python jceks.py <path to jceks file>")
        sys.exit(1)
    if os.path.exists(sys.argv[1]) == False:
        print(sys.argv[1] + ' does not exist')
        sys.exit(1)
    with open('./Test.java', 'w') as java_file:
        java_file.write(java_code)

    retcode = subprocess.call(['javac', '-cp', '/usr/hdp/current/hadoop-client/*:/usr/hdp/current/hadoop-client/lib/*:.', 'Test.java'])
    if retcode == 0:
        output = subprocess.check_output(['java', '-cp', '/usr/hdp/current/hadoop-client/*:/usr/hdp/current/hadoop-client/lib/*:.', 'Test', 'localjceks://file' + sys.argv[1]])
        print(output)
        os.remove('./Test.java')
    else:
        sys.exit(1)



if __name__ == "__main__":
    main()
